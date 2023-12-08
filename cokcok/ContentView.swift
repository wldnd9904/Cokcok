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
    @EnvironmentObject var model: ModelData
    @State private var selectedTab: Tab = .summary
    @State private var showNewUserView:(String, String, AuthType)?
    var body: some View {
        VStack{
            if(model.signState == .signIn) {
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
                        Summary()
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
                    .tag(Tab.matches)
                    
                }
                .background(.thinMaterial)
                .font(.headline)
            } else {
                if(showNewUserView != nil){
                    NewUserView(manager: NewUserManager(id: showNewUserView!.0, email: showNewUserView!.1, authType: showNewUserView!.2){user in
                        Task {
                            await model.signUpAndSetEmptyData(user:user)
                            withAnimation{
                                showNewUserView = nil
                            }
                        }
                    })
                } else {
                    LoginView(authManager: AuthenticationManager{ uid, email, authType in
                        Task {
                            print("gd")
                                await model.signInAndGetData(token:uid!) {showNewUserView = (uid!, email!, authType!)}
                        }})
                }
            }
        }.onAppear {
            if Auth.auth().currentUser != nil {
                print(Auth.auth().currentUser?.uid ?? "")
                Task{
                    await model.signInAndGetData(token: Auth.auth().currentUser!.uid){}
                }
            }
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(ModelData())
}
