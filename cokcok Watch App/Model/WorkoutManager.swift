//
//  WorkoutManager.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import Foundation
import HealthKit
import CoreMotion
import WatchKit
import WatchConnectivity

enum WorkoutState {
    case idle, running, pause, saving1, saving2, sending, sent, saved, error, ended
    var message: String {
        switch(self) {
        case .idle:"대기"
        case .running:"경기 기록 중"
        case .pause:"일시 정지"
        case .saving1:"운동 정보를 저장하는 중"
        case .saving2:"경기 결과를 저장하는 중"
        case .sending:"경기 결과를 서버에 전송하는 중"
        case .sent:"전송 완료"
        case .saved:"전송 실패. 경기 결과를 내부 저장소에 임시로 저장합니다."
        case .error:"오류가 발생했습니다. 처음으로 돌아갑니다."
        case .ended:"경기 기록 종료"
        }
    }
}

class WorkoutManager: NSObject, ObservableObject {
    @Published var showingSummaryView: Bool = false {
        didSet {
            // Sheet dismissed
            if showingSummaryView == false {
                resetWorkout()
            }
        }
    }
    let healthStore = HKHealthStore()
    var session: HKWorkoutSession?
    var builder: HKLiveWorkoutBuilder?
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let wcsession:WCSession
    var user: User?
    
    override init() {
        wcsession = .default
        super.init()
        wcsession.delegate = self
        do {
            try login()
        } catch {
            print(error.localizedDescription)
#if targetEnvironment(simulator)
            self.user = .demo
#else
            self.user = nil
#endif
        }
        do{
            try trySendingRemainingFiles()
        }catch{}
    }
    
    func startWorkout() {
        //시뮬레이터에서는 검사 안 함
        #if targetEnvironment(simulator)
        #else
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        #endif
        if state != .idle { return }
        self.state = .running
        matchSummary = MatchSummary(id: 0, startDate: Date(), endDate: Date(), duration: 0, totalDistance: 0, totalEnergyBurned: 0, averageHeartRate: 0, myScore: 0, opponentScore: 0, history:"")
        print("matchsummary = \(matchSummary!.id)")
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .badminton
        configuration.locationType = .indoor

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }

        builder?.dataSource = HKLiveWorkoutDataSource(
            healthStore: healthStore,
            workoutConfiguration: configuration
        )
        
        session?.delegate = self
        builder?.delegate = self
        // Start the workout session and begin data collection.
        let startDate = Date()
        session?.startActivity(with: startDate)
        startRecordingDeviceMotion()
        builder?.beginCollection(withStart: startDate) { (success, error) in
            if success {
                DispatchQueue.main.async { print("builder.beginCollection()") }
            }
            if (error != nil) {
                print(error!)
            }
        }
    }
    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType(),
        ]

        // The quantity types to read from the health store.
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.activitySummaryType()
        ]

        // Request authorization for those quantity types.
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            // Handle error.
        }
    }
    
    // MARK: - State Control

    // The workout session state.
    @Published var state :WorkoutState = .idle

    func pause() {
        print("pause")
        state = .pause
        motionManager.stopDeviceMotionUpdates()
        session?.pause()
    }

    func resume() {
        print("resume")
        state = .running
        motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            self.recordedMotion.append(data)
        }
        session?.resume()
    }

    func togglePause() {
        if state == .running {
            pause()
        } else {
            resume()
        }
    }

    func endWorkout() {
        showingSummaryView = true
        session?.end()
    }
    
    // MARK: - Match Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    @Published var matchSummary: MatchSummary?
    private var recordedMotion:[CMDeviceMotion] = []
    
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    func resetWorkout() {
        state = .ended
        builder = nil
        session = nil
        matchSummary = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) {

        // Wait for the session to transition states before ending the builder.
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (success, error) in
                DispatchQueue.main.async {
                    self.state = .saving1
                    self.builder?.finishWorkout { (workout, error) in
                        DispatchQueue.main.async {
                            self.matchSummary?.averageHeartRate = self.averageHeartRate
                            self.matchSummary?.duration = workout?.duration ?? 0
                            self.matchSummary?.startDate = workout?.startDate ?? Date()
                            self.matchSummary?.endDate = workout?.endDate ?? Date()
                            self.matchSummary?.totalEnergyBurned = workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
                            self.matchSummary?.totalDistance = workout?.totalDistance?.doubleValue(for: .meter()) ?? 0
                            print("\(String(describing: self.matchSummary?.averageHeartRate)), \(String(describing: self.matchSummary?.duration)), \(String(describing: self.matchSummary?.startDate))")
                            self.endRecordingDeviceMotion()
                        }
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { return }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // Update the published values.
            updateForStatistics(statistics)
        }
    }
}

// MARK: - 손목 데이터 녹화 관련
extension WorkoutManager {
    private func startRecordingDeviceMotion() {
        motionManager.deviceMotionUpdateInterval = 1/50
        recordedMotion.removeAll()
        motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            self.recordedMotion.append(data)
        }
    }
    private func endRecordingDeviceMotion() {
        motionManager.stopDeviceMotionUpdates()
        print(self.recordedMotion.count)
        // saving2: 메타데이터는 json, 모션 데이터는 csv파일로 저장
        self.state = .saving2
        guard let matchSummary = self.matchSummary else {
            self.state = .error
            return
        }
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "\(matchSummary.id)") else {
            self.state = .error
            return
        }
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            try DataManager.shared.saveToJSONFile(matchSummary, to: directoryURL.appending(path:"matchSummary.json"))
            try DataManager.shared.saveMotionDataToCSV(self.recordedMotion, filePath: directoryURL.appending(path:"motionData.csv"), xyReversed: WKInterfaceDevice.current().crownOrientation == .left)
        } catch {
            self.state = .error
            return
        }
        Task {
            DispatchQueue.main.async{
                self.state = .sending
            }
            do {
                //파일 서버로 보내기
                guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "\(matchSummary.id)") else {fatalError()}
                let metaDataURL = directoryURL.appending(path:"matchSummary.json")
                let motionDataURL = directoryURL.appending(path:"motionData.csv")
                try APIManager.shared.uploadMatch(token: user!.id, metaDataURL: metaDataURL, motionDataURL: motionDataURL, onDone: {
                    do {
                        DispatchQueue.main.async {
                            self.state = .sent
                        }
                        //보냈으면 삭제
                        try FileManager.default.removeItem(at:directoryURL)
                        DispatchQueue.main.async{
                            self.state = .ended
                        }
                    } catch {
                        fatalError()
                    }
                })
            }catch {
                //못보내면 일단 저장만하기
                DispatchQueue.main.async{
                    self.state = .saved
                }
                return
            }
        }
    }
    
    func trySendingRemainingFiles() throws {
        //파일 전부 보내기 시도, 보내면 삭제
        //파일 서버로 보내기
        if user==nil {return }
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
        fileURLs.forEach{ uid in
            print(uid.lastPathComponent)
            do{
                //파일 서버로 보내기
                let directoryURL = documentsURL.appending(path: uid.lastPathComponent)
                let metaDataURL = directoryURL.appending(path:"matchSummary.json")
                let motionDataURL = directoryURL.appending(path:"motionData.csv")
                if FileManager.default.fileExists(atPath: metaDataURL.path()) && FileManager.default.fileExists(atPath: motionDataURL.path()){
                    try APIManager.shared.uploadMatch(token: user!.id, metaDataURL: metaDataURL, motionDataURL: motionDataURL, onDone: {
                        do {
                            //보냈으면 삭제
                            try FileManager.default.removeItem(at:directoryURL)
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                } else {return}
            }catch{
                //못보내도 상관없음
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - 유저데이터 관련
extension WorkoutManager {
    func login() throws {
            let userDataURL = FileManager.default.urls(for:.documentDirectory,in:.userDomainMask).first?.appending(path:"userData.json")
            let userData = try Data(contentsOf: userDataURL!)
            // JSON 디코딩을 통해 User 객체로 변환
            let decoder = JSONDecoder()
            self.user = try decoder.decode(User.self, from: userData)
    }
    func logout() throws {
        let userDataURL = FileManager.default.urls(for:.documentDirectory,in:.userDomainMask).first?.appending(path:"userData.json")
        try FileManager.default.removeItem(at:userDataURL!)
        self.user = nil
    }
}

// MARK: - 애플워치 세션 델리게이트
extension WorkoutManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    private func session(_ session: WCSession, didReceiveMessage message: [String : User]) {
        if let userData = message["userData"]{
            let fileManager = FileManager.default
            // Document 디렉토리의 URL 가져오기
            if let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                do {
                    // User 객체를 JSON 데이터로 인코딩
                    let encoder = JSONEncoder()
                    let userDataData = try encoder.encode(user)
                    // userData.json 파일의 URL
                    let userDataURL = documentsURL.appendingPathComponent("userData.json")
                    // 파일에 JSON 데이터 쓰기
                    try userDataData.write(to: userDataURL)
                    print("User 데이터를 저장했습니다: \(userDataURL.path)")
                    DispatchQueue.main.async{
                        self.user = userData
                    }
                } catch {
                    print("User 데이터 저장 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
