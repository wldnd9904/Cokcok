//
//  cokcokApp.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import WatchKit
import HealthKit


class MyWatchAppDelegate: NSObject, WKApplicationDelegate {
    var presetDestination: MenuType?
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        PathManager.shared.path = [.swingRecord]
    }
}

@main
struct cokcok_Watch_AppApp: App {
    @StateObject var workoutManager = WorkoutManager()
    @StateObject var pathManager = PathManager.shared
    @WKApplicationDelegateAdaptor var appDelegate: MyWatchAppDelegate
    @State var path:[MenuType] = []
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                StartView(path: $pathManager.path)
            }
            .sheet(isPresented: $workoutManager.showingSummaryView) {
                SummaryView()
            }
            .environmentObject(workoutManager)
        }
    }
}
