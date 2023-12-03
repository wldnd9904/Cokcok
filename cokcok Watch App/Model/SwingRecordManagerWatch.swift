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

enum SwingRecordState: Equatable {
    case idle, running, saving, sending, sent, saved, error(String), ended
    var message: String {
        switch(self) {
        case .idle:"대기"
        case .running:"스윙 기록 중"
        case .saving:"데이터 저장 중"
        case .sending:"아이폰으로\n데이터를 전송하는 중"
        case .sent:"전송 완료"
        case .saved:"전송 실패."
        case .error(let detail):"오류: \(detail)."
        case .ended:"기록 종료"
        }
    }
    func isError() -> Bool {
        switch(self){
        case .error(_):
             return true
        default:
            return false
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
        do {
            try startHKSession()
        } catch {
            return
        }
        self.isReachable = wcsession.isReachable
        session.activate()
        self.wcsession.sendMessage(["message":"swingrecord"], replyHandler: nil)
    }
    deinit{
        endHKSession()
        self.wcsession.sendMessage(["message":"startview"], replyHandler: nil)
        self.wcsession.delegate = nil
    }
    func startRecording() {
        if self.state != .idle { return }
        if(self.wcsession.isReachable) {
            self.wcsession.sendMessage(["message":"start"], replyHandler: nil)
        }
        self.state = .running
        self.recordedMotion.removeAll()
        self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                self.state = .error("데이터 기록 실패")
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
        DispatchQueue.main.async {
            guard let tmpFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                self.state = .error("데이터 저장 실패")
                return
            }
            do {
                try DataManager.shared.saveMotionDataToCSV(self.recordedMotion, filePath: tmpFileURL.appending(path:"swingData.csv"), xyReversed: WKInterfaceDevice.current().crownOrientation == .left)
            } catch {
                self.state = .error("데이터 전송 실패")
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
        DispatchQueue.main.async {
            if let data = message["preview"] as? Data, let image = UIImage(data: data) {
                self.livePreviewImageView = image
            }
            switch(message["message"] as? String) {
            case "received" :
                self.state = .ended
            default:
                break
            }
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
    
