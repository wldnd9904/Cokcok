//
//  WorkoutManager.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import Foundation
import HealthKit
import CoreMotion

enum WorkoutState {
    case idle, running, pause, saving1, saving2, sending, sent, saved, error
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
    
    func startWorkout() {
        guard motionManager.isDeviceMotionAvailable else {
            return
        }
        if state != .idle { return }
        matchSummary = MatchSummary(id: UUID(), startDate: Date(), endDate: Date(), duration: 0, totalDistance: 0, totalEnergyBurned: 0, averageHeartRate: 0, myScore: 0, opponentScore: 0, myScoreHistory: [], opponentScoreHistory: [])
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .badminton
        configuration.locationType = .indoor

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            // Handle any exceptions.
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
                self.state = .running
            }
        }
    }
    
    // Request authorization to access HealthKit.
    func requestAuthorization() {
        // The quantity type to write to the health store.
        let typesToShare: Set = [
            HKQuantityType.workoutType()
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
        state = .pause
        session?.pause()
    }

    func resume() {
        state = .running
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
        session?.end()
        showingSummaryView = true
    }
    
    // MARK: - Match Metrics
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance: Double = 0
    var matchSummary: MatchSummary?
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
                self.state = .saving1
                self.builder?.finishWorkout { (workout, error) in
                    DispatchQueue.main.async {
                        self.matchSummary?.averageHeartRate = self.averageHeartRate
                        self.matchSummary?.duration = workout?.duration ?? 0
                        self.matchSummary?.startDate = workout?.startDate ?? Date()
                        self.matchSummary?.endDate = workout?.endDate ?? Date()
                        self.matchSummary?.totalEnergyBurned = workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0
                        self.matchSummary?.totalDistance = workout?.totalDistance?.doubleValue(for: .meter()) ?? 0
                        self.endRecordingDeviceMotion()
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
        print(recordedMotion.count)
        //TODO: 메타데이터는 json, 모션 데이터는 csv파일로 저장
        self.state = .saving2
        
        //TODO: 서버로 전송 시도
        self.state = .sending
        
        //TODO: 보내졌다면 저장한 파일 삭제
        self.state = .sent //보내졌을 때
        
        //TODO: 못보냈다면 일단 내부에 저장
        self.state = .saved //못보냈을 때
    }
}
