//
//  ControlsView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        if workoutManager.matchSummary == nil {
            Button(action: {
                workoutManager.startWorkout()
            }){
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.green)
            }
            .buttonStyle(.plain)
        }
        else {
            HStack {
                VStack {
                    Button {
                        workoutManager.endWorkout()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .tint(Color.red)
                    .font(.title2)
                    Text("종료")
                }
                VStack {
                    Button {
                        workoutManager.togglePause()
                    } label: {
                        Image(systemName: workoutManager.state == .running ? "pause" : "play")
                    }
                    .tint(Color.yellow)
                    .font(.title2)
                    Text(workoutManager.state == .running ? "일시정지" : "재개")
                }
            }
        }
    }
}

#Preview {
    ControlsView()
        .environmentObject(WorkoutManager())
}
