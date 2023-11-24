//
//  ContentView.swift
//  cokcok
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import FirebaseAuth

private enum Tab:Hashable {
    case swing, summary, matches
}

struct ContentView : View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedTab: Tab = .summary
    @State private var showMyPage:Bool = false
    var body: some View {
        VStack{
            if(authManager.signState == .signIn) {
                TabView(selection: $selectedTab) {
                    NavigationStack{
                        SwingView()
                            .navigationTitle("스윙 분석")
                    }
                    .tabItem {
                        Image(systemName: "figure.badminton")
                        Text("스윙 분석")
                    }
                    .tag(Tab.swing)
                    
                    NavigationStack{
                        Summary(showMyPage:$showMyPage)
                            .navigationTitle("요약")
                    }
                    .tabItem {
                        Image(systemName: "list.bullet.clipboard")
                        Text("요약")
                    }
                    .tag(Tab.summary)
                    
                    NavigationStack {
                        Matches()
                            .navigationTitle("경기 분석")
                    }
                    .tabItem {
                        Image(systemName: "waveform.path.ecg.rectangle")
                        Text("경기 분석")
                    }
                    .badge(10)
                    .tag(Tab.matches)
                    
                }
                .background(.thinMaterial)
                .font(.headline)
            } else {
                LoginView()
            }
        }                
        .onAppear {
            if Auth.auth().currentUser != nil {
                authManager.signState = .signIn
            }
            #if DEBUG
            authManager.signState = .signIn
            #endif
        }
        .sheet(isPresented: $showMyPage, content: {
            MyPage(isPresented: $showMyPage)
        })
    }
}
#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
        .environmentObject(ModelData())
}
