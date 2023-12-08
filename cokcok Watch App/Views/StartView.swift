//
//  ContentView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import HealthKit


struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var path: [MenuType]
    var body: some View {
        NavigationStack(path:$path){
            VStack(alignment:.center){
                Text("COKCOK").font(.headline).foregroundStyle(.green)
                if(workoutManager.user == nil){
                    Text("사용자 정보가 없습니다.\n이 화면을 유지한 상태로 iPhone에서 콕콕 앱에 로그인 해주세요.")
                } else {
                    Spacer()
                    HStack{
                        Image(systemName: "person")
                        VStack{
                            Text("\(workoutManager.user!.email)")
                            Text("\(workoutManager.user!.authType.rawValue) 계정")
                        }
                        Button{
                            do {
                                try workoutManager.logout()
                            }catch {
                                print(error.localizedDescription)
                            }
                        }label: {
                            Image(systemName: "xmark.circle")
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                    HStack{
                        NavigationLink(value: MenuType.swingRecord){
                            Text(MenuType.swingRecord.name)
                        }
                        .tint(.blue)
                        NavigationLink(value: MenuType.matchRecord){
                            Text(MenuType.matchRecord.name)
                        }
                        .tint(.green)
                    }
#if targetEnvironment(simulator)
                    NavigationLink(value: MenuType.savedData){
                        Text(MenuType.savedData.name)
                    }
#endif
                    Spacer()
                }
            }
            .navigationDestination(for: MenuType.self) { menuType in
                switch menuType {
                case .swingRecord:
                    SwingRecordWatchView()
                case .matchRecord:
                    SessionPagingView(path: $path)
                case .savedData:
                    SavedDataView()
                }
            }
        }
        .onChange(of: workoutManager.state) {
            if workoutManager.state == .ended {
                path = []
            }
        }
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

#Preview {
    NavigationView{
        StartView(path: .constant([]))
            .environmentObject(WorkoutManager())
    }
}
