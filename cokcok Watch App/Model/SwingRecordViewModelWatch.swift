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

class SwingRecordViewModelWatch: NSObject, ObservableObject {
    var wcsession: WCSession
    var hksession: HKWorkoutSession?
    var motionManager: CMMotionManager
    var queue: OperationQueue
    let healthStore = HKHealthStore()
    
    @Published var isRecording: Bool = false
    @Published var record: [MyDeviceMotion] = []
    @Published var firstTimeStamp: Double = 0
    @Published var livePreviewImageView: UIImage = UIImage()
    
    init(session: WCSession = .default) {
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 0.02
        self.queue = OperationQueue()
        self.wcsession = session
        super.init()
        self.wcsession.delegate = self
        session.activate()
    }

    func startRecording() {
        if self.isRecording { return }
        if(self.wcsession.isReachable) {
            self.wcsession.sendMessage(["message":"start"], replyHandler: nil)
        }
        do {
            try startHKSession()
        } catch {
            return
        }
        self.isRecording = true
        self.firstTimeStamp = 0
        self.record.removeAll()
        self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }
            if self.firstTimeStamp == 0 {
                self.firstTimeStamp = data.timestamp
            }
            let myData = MyDeviceMotion(
                timestamp: data.timestamp - self.firstTimeStamp,
                attitude: MyDeviceMotion.MyAttitude(
                    pitch: String(format: "%.6f", data.attitude.pitch),
                    yaw: String(format: "%.6f", data.attitude.yaw),
                    roll: String(format: "%.6f", data.attitude.roll)
                ),
                userAcceleration: MyDeviceMotion.MyAcceleration(
                    x: String(format: "%.6f", data.userAcceleration.x),
                    y: String(format: "%.6f", data.userAcceleration.y),
                    z: String(format: "%.6f", data.userAcceleration.z)
                )
            )
            self.record.append(myData)
        }
    }
    func stopRecording() {
        if !self.isRecording { return }
        self.isRecording = false
        self.motionManager.stopDeviceMotionUpdates()
        if(self.wcsession.isReachable){
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(self.record)
                self.wcsession.sendMessageData(data, replyHandler: nil)
            } catch {
            }
            self.wcsession.sendMessage(["message":"stop"], replyHandler: nil)
        }
        endHKSession()
    }
}

// MARK: - 애플워치 세션 델리게이트
extension SwingRecordViewModelWatch: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let data = message["preview"] as? Data, let image = UIImage(data: data) {
                self.livePreviewImageView = image
            }
            switch(message["message"] as? String) {
            case "start" : self.startRecording()
            case "stop" : self.stopRecording()
            default: break
            }
        }
    }
}

// MARK: - 헬스킷 워크아웃 세션 델리게이트
extension SwingRecordViewModelWatch {
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
    
