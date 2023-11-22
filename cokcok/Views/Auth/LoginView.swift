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
        ZStack{
            Color(red:46/255, green:204/255, blue: 113/255)
            VStack {
                Spacer()
                
                Text("COKCOK")
                    .font(.system(size: 50, weight: .black, design: .default))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    isShowingProgressView = true
                    authManager.signIn()
                } label: {
                    HStack{
                        Image("google")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width:25,height:25)
                            .padding(.top,7)
                        Text("Google로 로그인")
                    }
                }
                .font(.headline)
                .foregroundColor(Color(red:31/255, green:31/255, blue: 31/255))
                .padding()
                .frame(width: 240, height: 50)
                .background(.white)
                .cornerRadius(15)
                
                Button {
                    isShowingProgressView = true
                    authManager.kakaoAuthSignIn()
                } label: {
                    HStack{
                        Image("kakao")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width:25,height:25)
                            .padding(.top,7)
                        Text("카카오로 로그인")
                            .padding(.trailing,3)
                    }
                }
                .font(.headline)
                .foregroundColor(Color(red:58/255, green:29/255, blue: 29/255))
                .padding()
                .frame(width: 240, height: 50)
                .background(Color(red: 247 / 255, green: 230 / 255, blue: 0 / 255))
                .cornerRadius(15.0)
                
                Button {
                    isShowingProgressView = true
                    authManager.startAppleLogin(window: window)
                } label:{
                    HStack{
                        Image(systemName: "apple.logo")
                            .scaleEffect(1.5)
                        Text(" Apple로 로그인")
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 240, height: 50)
                .background(.black)
                .cornerRadius(15.0)
                
                
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationManager())
}
