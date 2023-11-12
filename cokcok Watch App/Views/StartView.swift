//
//  ContentView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import HealthKit
enum MenuType: UInt, Identifiable, CaseIterable, Hashable {
    case swingRecord, matchRecord, savedData
    
    public var id:UInt {
        rawValue
    }
    var name: String {
        switch self {
        case .swingRecord:
            return "스윙 분석"
        case .matchRecord:
            return "경기 기록"
        case .savedData:
            return "Debug: 저장된 경기 확인"
        }
    }
}

struct StartView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State var path: [MenuType] = []
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
        StartView()
            .environmentObject(WorkoutManager())
    }
}
