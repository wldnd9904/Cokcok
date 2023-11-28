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
            List{
                NavigationLink(value: MenuType.swingRecord){
                    Text(MenuType.swingRecord.name)
                }
                NavigationLink(value: MenuType.matchRecord){
                    Text(MenuType.matchRecord.name)
                }
                NavigationLink(value: MenuType.savedData){
                    Text(MenuType.savedData.name)
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
