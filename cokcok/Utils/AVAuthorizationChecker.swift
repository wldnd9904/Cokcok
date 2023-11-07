//
//  AVAuthorizationChecker.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import AVFoundation

struct AVAuthorizationChecker {
    static func checkCaptureAuthorizationStatus() async -> Status {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .permitted
            
        case .notDetermined:
            let isPermissionGranted = await AVCaptureDevice.requestAccess(for: .video)
            if isPermissionGranted {
                return .permitted
            } else {
                fallthrough
            }
            
        case .denied:
            fallthrough
            
        case .restricted:
            fallthrough
            
        @unknown default:
            return .notPermitted
        }
    }
}

extension AVAuthorizationChecker {
    enum Status {
        case permitted
        case notPermitted
    }
}
