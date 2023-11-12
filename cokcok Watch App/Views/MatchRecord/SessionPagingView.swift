//
//  SessionPagingView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import WatchKit

struct SessionPagingView: View {
    @Environment(\.isLuminanceReduced) var isLuminanceReduced
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selection: Tab = .controls
    @Binding var path: [MenuType]
    
    enum Tab {
        case controls, metrics, score
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ControlsView(path: $path).tag(Tab.controls)
            if workoutManager.state != .idle {
                MetricsView().tag(Tab.metrics)
                ScoreView().tag(Tab.score)
            }
        }
        .navigationBarBackButtonHidden(workoutManager.state != .idle)
        .navigationTitle("경기 기록")
        .onChange(of: workoutManager.state) {
            withAnimation{
                if workoutManager.state == .running {
                    displayView(.score)
                }
                if workoutManager.state == .pause {
                    displayView(.metrics)
                }
            }
        }
        .tabViewStyle(
            PageTabViewStyle(indexDisplayMode: isLuminanceReduced ? .never : .automatic)
        )
        .onAppear{
            workoutManager.state = .idle
        }
    }
    
    private func displayView(_ tab: Tab) {
        withAnimation {
            selection = tab
        }
    }
}

#Preview {
    SessionPagingView(path:.constant([.matchRecord]))
        .environmentObject(WorkoutManager())
}
