//
//  LoginView.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State var isShowingProgressView = false                   // 로그인 비동기 ProgressView
    @State var isShowingAlert: Bool = false                     // 로그인 완료 Alert
    @Environment(\.window) var window: UIWindow?

    var body: some View {
        
        VStack {
            Button {
                isShowingProgressView = true
                authManager.signIn()
            } label: {
                Text("Google Account Login")
            }
            Button {
                isShowingProgressView = true
                authManager.kakaoAuthSignIn()
            } label: {
                Image("kakao_login_medium_narrow")
                    .renderingMode(.original)
            }
            
            Button {
                isShowingProgressView = true
                authManager.startAppleLogin(window: window)
            } label: {
                Image("appleid_button-2")
                    .renderingMode(.original)
            }

        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
}
