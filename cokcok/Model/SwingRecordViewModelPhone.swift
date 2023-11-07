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

class SwingRecordViewModelPhone: NSObject, ObservableObject {
    @Published var preview: AVPreview?
    @Published var isRecording: Bool = false
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
        self.wcsession = WCSession.default
        self.videoOutput = AVCaptureVideoDataOutput()
        super.init()
        self.avsession.addOutput(videoOutput)
        self.wcsession.delegate = self
        self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        self.wcsession.activate()
        
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
        if self.isRecording { return }
        guard wcsession.isReachable else {
            print("Cannot find reachable Apple Watch")
            return
        }
        guard let output = avsession.movieFileOutput else {
            print("Cannot find movie file output")
            return
        }
        self.wcsession.sendMessage(["message":"start"], replyHandler: nil)
        self.isRecording = true
        
        // Documents 디렉토리 경로 가져오기
        let fileManager = FileManager.default
        let folderName = "swing-\(Date())"
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Cannot access local file domain")
            return
        }
        do {
            // 폴더 경로 설정
            let folderPath = documentsDirectory.appendingPathComponent(folderName)
            try fileManager.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
            let filePath = folderPath.appendingPathComponent("Video.mp4")
            // 녹화 시작
            output.startRecording(to: filePath, recordingDelegate: self)
        } catch {
            print("Error creating folder or starting recording: \(error)")
        }
    }
    
    func stopRecording() {
        if !self.isRecording { return }
        if(self.wcsession.isReachable) {
            self.wcsession.sendMessage(["message":"stop"], replyHandler: nil)
        }
        self.isRecording = false
        guard let output = self.avsession.movieFileOutput else {
            print("Cannot find movie file output")
            return
        }
        output.stopRecording()
    }
}

// MARK: - 애플워치 세션 델리게이트
extension SwingRecordViewModelPhone: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            switch(message["message"] as? String) {
                case "start" : self.startRecording()
                case "stop" : self.stopRecording()
                default: break
            }
        }
    }
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        // 데이터를 파일로 저장
        DispatchQueue.main.async {
            // Documents 디렉토리 경로 가져오기
            guard let folderName = self.folderName else {
                return
            }
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                print("Cannot access local file domain")
                return
            }
            // 폴더 경로 설정
            let folderPath = documentsDirectory.appendingPathComponent(folderName)
            
            // 폴더가 존재하지 않는 경우 생성
            do {
                try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed Creating Directory")
            }
            // 모션 파일 경로 설정
            let filePath = folderPath.appendingPathComponent("MotionData.json")
            do {
                try messageData.write(to: filePath)
                print("Received data saved to \(filePath)")
            } catch {
                print("Error saving received data: \(error)")
            }
        }
    }
}

// MARK: - 녹화 파일 아웃풋 델리게이트
extension SwingRecordViewModelPhone: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Video record is finished!")
    }
}

// MARK: 카메라 화면 애플워치와 공유
extension SwingRecordViewModelPhone: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Get TimeStamp
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        let timestampInSec = timestamp.seconds
        // Check timestamp interval
        if(isRecording) { return }
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
extension SwingRecordViewModelPhone {
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
