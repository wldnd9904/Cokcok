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

enum SwingRecordManagerPhoneState: Equatable {
    case idle, running, saving, receiving, saved, sending, sent, error(String)
    var message: String {
        switch(self) {
        case .idle:"대기"
        case .running:"스윙 기록 중"
        case .saving:"영상을 저장하는 중"
        case .receiving:"손목 데이터 수신 중"
        case .saved:"실력 측정 준비 완료"
        case .sending:"영상과 손목 데이터를 서버에 전송하는 중"
        case .sent:"전송 완료"
        case .error(let detail):"오류: \(detail)."
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

class SwingRecordManagerPhone: NSObject, ObservableObject {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    @Published var preview: AVPreview?
    @Published var state: SwingRecordManagerPhoneState = .idle
    @Published var isReachable: Bool = false
    @Published var isButtonActivated: Bool = true
    var fileReceived: Bool = false
    
    let wcsession: WCSession
    let avsession: AVCaptureSession
    var folderName: String
    
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
        self.folderName = "swing-\(Date())"
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
            return
        }
        guard let output = avsession.movieFileOutput else {
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
                    guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        print("Cannot access local file domain")
                        return
                    }
                    do {
                        // 폴더 경로 설정
                        let folderPath = documentsDirectory.appendingPathComponent(self.folderName)
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
                    self.state = .error("녹화 시작 실패")
                    self.isButtonActivated = true
                }
            })
            //체크 실패 시
        }, errorHandler: {  checkError in
            DispatchQueue.main.async{
                self.state = .error("애플워치 통신 실패")
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
            self.state = .error("동영상 저장 실패")
            return
        }
        output.stopRecording()
        if(self.state == .saving) {self.state = .receiving}
        self.wcsession.sendMessage(["message":"check"], replyHandler: { checkResponse in
            DispatchQueue.main.async{
                if(self.fileReceived) {self.state = .saved}
                self.wcsession.sendMessage(["message":"stop"], replyHandler: {stopResponse in
                    //스탑 실패 시
                }, errorHandler: { startError in
                    DispatchQueue.main.async{
                        self.state = .error("녹화 종료 실패")
                        self.isButtonActivated = true
                    }
                })
            }
            //체크 실패 시
        }, errorHandler: {  checkError in
            DispatchQueue.main.async{
                self.state = .error("애플워치 통신 실패")
                self.isReachable = false
                self.isButtonActivated = true
            }
        })
    }
    
    func resetRecording(){
        self.state = .idle
        self.folderName = "swing-\(Date())"
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
                case "startview" : self.isReachable = false
                default: break
            }
        }
    }
    //애플워치로부터 스윙 데이터 수신
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        //상태가 receiving이 아니어도 저장
        DispatchQueue.main.async {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let folderPath = documentsURL?.appendingPathComponent(self.folderName)
            let destinationURL = folderPath?.appendingPathComponent(file.fileURL.lastPathComponent)
            do {
                try fileManager.moveItem(at: file.fileURL, to: destinationURL!)
                print("Received file at: \(destinationURL!.path)")
                // 다 받았을 때 수신중이었다면 바로 전송
                self.fileReceived = true
                self.wcsession.sendMessage(["message":"received"], replyHandler: nil)
                print(self.state.message)
                if(self.state == .receiving) {
                    self.state = .saved
                }
            } catch {
                print("Error moving file: \(error.localizedDescription)")
                self.state = .error("데이터 저장 실패")
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
    func uploadSwing(){
        //guard self.state == .saved
        //else {
        //    return
        //}
        self.state = .sending
        DispatchQueue.main.async {
            // Documents 디렉토리 경로 가져오기
            let fileManager = FileManager.default
            guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                self.state = .error("파일 전송 실패")
                return
            }
            do {
                // 폴더 경로 설정
                let folderPath = documentsDirectory.appendingPathComponent(self.folderName)
                try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
                let videoPath = folderPath.appendingPathComponent("Video.mp4")
                let motionPath = folderPath.appendingPathComponent("swingData.csv")
                
                try APIManager.shared.uploadSwing(token: "test", videoURL: videoPath, motionDataURL: motionPath){
                    print($0)
                    self.state = .sent
                }
            }
            catch {
                print(error)
            }
        }
    }
}
