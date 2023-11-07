//
//  ContentView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import HealthKit
enum MenuType: UInt, Identifiable, CaseIterable {
    case skillEstimate
    case matchRecord
    
    public var id:UInt {
        rawValue
    }
    var name: String {
        switch self {
        case .skillEstimate:
            return "실력 측정"
        case .matchRecord:
            return "경기 기록"
        }
    }
}

struct StartView: View {
    @EnvironmentObject var workoutManager : WorkoutManager
    var menuTypes: [MenuType] = MenuType.allCases
    var body: some View {
        List(menuTypes) { menuType in
            NavigationLink(
                menuType.name,
                destination: SessionPagingView(),
                tag: menuType, selection: $workoutManager.selectedMenu)
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .listStyle(.carousel)
        .navigationBarTitle("메뉴")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

#Preview {
    NavigationView{
        StartView()
    }
    .environmentObject(WorkoutManager())
}
