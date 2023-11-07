//
//  ContentView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import HealthKit
enum MenuType: UInt, Identifiable, CaseIterable, Hashable {
    case swingRecord
    case matchRecord
    
    public var id:UInt {
        rawValue
    }
    var name: String {
        switch self {
        case .swingRecord:
            return "스윙 분석"
        case .matchRecord:
            return "경기 기록"
        }
    }
}

struct StartView: View {
    var menuTypes: [MenuType] = MenuType.allCases
    var body: some View {
        NavigationStack{
            List{
                NavigationLink(value: MenuType.swingRecord){
                    Text(MenuType.swingRecord.name)
                }
                NavigationLink(value: MenuType.matchRecord){
                    Text(MenuType.matchRecord.name)
                }
            }
            .navigationDestination(for: MenuType.self) { menuType in
                switch menuType {
                case .swingRecord:
                    SwingRecordWatchView()
                case .matchRecord:
                    SessionPagingView()
                }
            }
        }
    }
}

#Preview {
    NavigationView{
        StartView()
    }
}
