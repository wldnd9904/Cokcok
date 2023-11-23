//
//  WCSessionViewModelWatch.swift
//  CokDataCollector Watch App
//
//  Created by 최지웅 on 9/24/23.
//

import Foundation
import WatchConnectivity
import CoreMotion
import HealthKit
import SwiftUI
import WatchKit

enum SwingRecordState {
    case idle, running, saving, sending, sent, saved, error, ended
    var message: String {
        switch(self) {
        case .idle:"대기"
        case .running:"스윙 기록 중"
        case .saving:"데이터 저장 중"
        case .sending:"iPhone으로 데이터를 전송하는 중"
        case .sent:"전송 완료"
        case .saved:"전송 실패. iPhone을 확인해주세요." 
        case .error:"오류가 발생했습니다. 처음으로 돌아갑니다."
        case .ended:"경기 기록 종료"
        }
    }
}

class SwingRecordManagerWatch: NSObject, ObservableObject {
    var wcsession: WCSession
    var hksession: HKWorkoutSession?
    var motionManager: CMMotionManager
    var queue: OperationQueue
    let healthStore = HKHealthStore()
    var recordedMotion: [CMDeviceMotion] = []
    
    @Published var isReachable: Bool = false
    @Published var state: SwingRecordState = .idle
    @Published var livePreviewImageView: UIImage = UIImage()
    
    init(session: WCSession = .default) {
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 0.02
        self.queue = OperationQueue()
        self.wcsession = session
        super.init()
        self.wcsession.delegate = self
        self.isReachable = wcsession.isReachable
        session.activate()
        self.wcsession.sendMessage(["message":"swingrecord"], replyHandler: nil)
        print("스윙레코드매니저 생성됨")
    }
    deinit{
        self.wcsession.delegate = nil
        print("스윙레코드매니저 제거됨")
    }
    func startRecording() {
        if self.state != .idle { return }
        if(self.wcsession.isReachable) {
            self.wcsession.sendMessage(["message":"start"], replyHandler: nil)
        }
        do {
            try startHKSession()
        } catch {
            return
        }
        self.state = .running
        self.recordedMotion.removeAll()
        self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            self.recordedMotion.append(data)
        }
    }
    func stopRecording() {
        if self.state != .running { return }
        if(self.wcsession.isReachable) {
            self.wcsession.sendMessage(["message":"stop"], replyHandler: nil)
        }
        self.state = .saving
        self.motionManager.stopDeviceMotionUpdates()
        endHKSession()
        print(self.recordedMotion.count)
        DispatchQueue.main.async {
            guard let tmpFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                self.state = .error
                return
            }
            do {
                try DataManager.shared.saveMotionDataToCSV(self.recordedMotion, filePath: tmpFileURL.appending(path:"swingData.csv"), xyReversed: WKInterfaceDevice.current().crownOrientation == .left)
            } catch {
                self.state = .error
                return
            }
            // iOS 앱으로 파일 전송
            self.state = .sending
            self.wcsession.transferFile(tmpFileURL.appending(path:"swingData.csv"), metadata: nil)
        }
    }
}

// MARK: - 애플워치 세션 델리게이트
extension SwingRecordManagerWatch: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let data = message["preview"] as? Data, let image = UIImage(data: data) {
            print("프레임 받음")
            self.livePreviewImageView = image
        }
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            switch(message["message"] as? String) {
            case "start" :
                self.startRecording()
                replyHandler(["result": "ok"])
            case "stop" :
                self.stopRecording()
                replyHandler(["result": "ok"])
            case "check" :
                replyHandler(["result": "ok"])
            case "recieved" :
                if self.state == .sending {
                    self.state = .idle
                    replyHandler(["result": "ok"])
                }
            default:
                replyHandler(["result": "no"])
                
            }
        }
    }
    func sessionReachabilityDidChange(_ session: WCSession) {
        self.isReachable = session.isReachable
    }
}

// MARK: - 헬스킷 워크아웃 세션 
extension SwingRecordManagerWatch {
    func startHKSession() throws {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .badminton
        configuration.locationType = .indoor
        hksession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
        let startDate = Date()
        hksession?.startActivity(with: startDate)
    }
    
    func endHKSession() {
        hksession?.end()
    }
}
    