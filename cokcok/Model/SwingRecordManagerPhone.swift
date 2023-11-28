//
//  SwingRecordViewModelPhone.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import Foundation
import WatchConnectivity
import AVFoundation
import UIKit
import SwiftUI
import HealthKit

enum SwingRecordManagerPhoneState {
    case idle, running, saving, recieving, sending, sent,  error
    var message: String {
        switch(self) {
        case .idle:"대기"
        case .running:"경기 기록 중"
        case .saving:"영상을 저장하는 중"
        case .sending:"영상과 손목 데이터를 서버에 전송하는 중"
        case .recieving:"손목 데이터 수신 중"
        case .sent:"전송 완료"
        case .error:"오류가 발생했습니다. 처음으로 돌아갑니다."
        }
    }
}

class SwingRecordManagerPhone: NSObject, ObservableObject {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    @Published var preview: AVPreview?
    @Published var state: SwingRecordManagerPhoneState = .idle
    @Published var errorMessage: String = ""
    @Published var isReachable: Bool = false
    @Published var isButtonActivated: Bool = true
    
    let wcsession: WCSession
    let avsession: AVCaptureSession
    var folderName: String?
    
    var prevTimestamp:Double = 0
    var minFrameInterval:Double = 0.08
    
    var front: Bool = false
    var videoOutput: AVCaptureVideoDataOutput
    var backCameraInput: AVCaptureInput!
    var frontCameraInput: AVCaptureInput!
    
    
    override init() {
        self.avsession = AVCaptureSession()
        self.avsession.sessionPreset = .medium
        self.wcsession = WCSession.default
        self.videoOutput = AVCaptureVideoDataOutput()
        super.init()
        self.avsession.addOutput(videoOutput)
        self.wcsession.delegate = self
        self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        self.wcsession.activate()
        self.isReachable = self.wcsession.isReachable
        
        Task(priority: .background) {
            switch await AVAuthorizationChecker.checkCaptureAuthorizationStatus() {
            case .permitted:
                try backCameraInput = avsession.getMovieInput(position: .back)
                try frontCameraInput = avsession.getMovieInput(position: .front)
                avsession.addInput(backCameraInput)
                
                try avsession
                    .addMovieFileOutput()
                    .startRunning()
                
                DispatchQueue.main.async {
                    self.preview = AVPreview(session: self.avsession, gravity: .resizeAspectFill)
                }
                
            case .notPermitted:
                break
            }
        }
    }
    
    func startRecording() {
        if self.state != .idle { return }
        guard wcsession.isReachable else {
            self.isReachable = false
            print("Cannot find reachable Apple Watch")
            errorMessage = "Cannot find reachable Apple Watch"
            return
        }
        guard let output = avsession.movieFileOutput else {
            print("Cannot find movie file output")
            errorMessage = "Cannot find movie file output"
            return
        }
        self.isButtonActivated = false
        //상태 체크
        self.wcsession.sendMessage(["message":"check"], replyHandler: { checkResponse in
            self.wcsession.sendMessage(["message":"start"], replyHandler: { startResponse in
                DispatchQueue.main.async {
                    self.state = .running
                    
                    // Documents 디렉토리 경로 가져오기
                    let fileManager = FileManager.default
                    self.folderName = "swing-\(Date())"
                    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        print("Cannot access local file domain")
                        return
                    }
                    do {
                        // 폴더 경로 설정
                        let folderPath = documentsDirectory.appendingPathComponent(self.folderName!)
                        try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
                        let filePath = folderPath.appendingPathComponent("Video.mp4")
                        // 녹화 시작
                        output.startRecording(to: filePath, recordingDelegate: self)
                    } catch {
                        print("Error creating folder or starting recording: \(error)")
                    }
                    self.isButtonActivated = true
                }
                //스타트 실패 시
            }, errorHandler: { startError in
                DispatchQueue.main.async{
                    self.state = .error
                    self.isButtonActivated = true
                }
            })
            //체크 실패 시
        }, errorHandler: {  checkError in
            DispatchQueue.main.async{
                self.state = .error
                self.isReachable = false
                self.isButtonActivated = true
            }
        })
    }
    
    func stopRecording() {
        if self.state != .running { return }
        guard self.wcsession.isReachable else {
            self.isReachable = false
            return
        }
        self.isButtonActivated = false
        self.state = .saving
        guard let output = self.avsession.movieFileOutput else {
            print("Cannot find movie file output")
            return
        }
        output.stopRecording()
        self.wcsession.sendMessage(["message":"check"], replyHandler: { checkResponse in
            DispatchQueue.main.async{
                self.state = .recieving
                self.wcsession.sendMessage(["message":"stop"], replyHandler: {stopResponse in
                    //스탑 실패 시
                }, errorHandler: { startError in
                    DispatchQueue.main.async{
                        self.state = .error
                        self.isButtonActivated = true
                    }
                })
            }
            //체크 실패 시
        }, errorHandler: {  checkError in
            DispatchQueue.main.async{
                self.state = .error
                self.isReachable = false
                self.isButtonActivated = true
            }
        })
    }
}

// MARK: - 애플워치 세션 델리게이트
extension SwingRecordManagerPhone: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {    }
    func sessionDidBecomeInactive(_ session: WCSession) {    }
    func sessionDidDeactivate(_ session: WCSession) {    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            withAnimation{
                if(self.state == .idle){
                    self.isReachable = session.isReachable
                }
            }
        }
    }
    
    //애플워치로부터 시작/종료 메시지 수신
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            switch(message["message"] as? String) {
                case "start" : self.startRecording()
                case "stop" : self.stopRecording()
                case "swingrecord" : self.isReachable = true
                default: break
            }
        }
    }
    //애플워치로부터 스윙 데이터 수신
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        guard self.state == .recieving else {
            return
        }
        DispatchQueue.main.async {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let folderPath = documentsURL?.appendingPathComponent(self.folderName!)
            let destinationURL = folderPath?.appendingPathComponent(file.fileURL.lastPathComponent)
            do {
                // 수신된 파일을 앱 내의 원하는 위치로 이동
                try fileManager.moveItem(at: file.fileURL, to: destinationURL!)
                print("Received file at: \(destinationURL!.path)")
                self.state = .sending
            } catch {
                print("Error moving file: \(error.localizedDescription)")
                self.state = .error
            }
        }
    }
    //애플워치 앱 열기
    func startCokcokWatchApp(){
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .badminton
        workoutConfiguration.locationType = .indoor
        if WCSession.isSupported(), WCSession.default.activationState == .activated , WCSession.default.isWatchAppInstalled{
            HKHealthStore().startWatchApp(with: workoutConfiguration, completion: { (success, error) in
                print(error.debugDescription)
            })
        }
    }
}

// MARK: - 녹화 파일 아웃풋 델리게이트
extension SwingRecordManagerPhone: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Video record is finished!")
    }
}

// MARK: 카메라 화면 애플워치와 공유
extension SwingRecordManagerPhone: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Get TimeStamp
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let timestampInSec = timestamp.seconds
        // Check timestamp interval
        guard timestampInSec - self.prevTimestamp > self.minFrameInterval else {
            return
        }
        self.prevTimestamp = timestampInSec
        if(self.wcsession.isReachable) {
            sendData(image: captureImage(sampleBuffer)!)
        }
    }
    func captureImage(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
      if let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
        let context = CIContext()
        if let image = context.createCGImage(ciImage, from: imageRect) {
          return UIImage(cgImage: image)
        }
      }
      return nil
    }
    func sendData(image: UIImage) {
      let data : Data?
      // Compress image
        data = image.jpegData(compressionQuality: 0)
        if let imageData = data {
            // Send data to Watch extension
            let message: [String : Any] = ["preview" : imageData]
            self.wcsession.sendMessage(message, replyHandler: nil)
        }
    }
}


// MARK: - 카메라 화면 전환
extension SwingRecordManagerPhone {
    func switchCameraInput() { //카메라 화면 전환
        //이렇게 값 변경할때 필요한 begin, commit!!
        avsession.beginConfiguration()
        if !front {
            avsession.removeInput(backCameraInput)
            avsession.addInput(frontCameraInput)
            front = true
        } else {
            avsession.removeInput(frontCameraInput)
            avsession.addInput(backCameraInput)
            front = false
        }
        avsession.commitConfiguration()
    }
}

// MARK: - 통신부
extension SwingRecordManagerPhone {
    
}
