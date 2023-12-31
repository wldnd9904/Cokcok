//
//  cokcokApp.swift
//  cokcok
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct cokcokApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "3355c78c4e56c0163218ff807374401a")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ModelData())
                .onOpenURL { url in // 뷰가 속한 Window에 대한 URL을 받았을 때 호출할 Handler를 등록하는 함수
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}
