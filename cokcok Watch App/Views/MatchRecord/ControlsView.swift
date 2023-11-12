//
//  ControlsView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var path: [MenuType]
    
    var body: some View {
        if workoutManager.state == .idle {
            CountDownView(count: 3, color: .green){
                if path.last == .matchRecord {
                    print("start")
                    workoutManager.startWorkout()
                }
            }
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
    ControlsView(path: .constant([.matchRecord]))
        .environmentObject(WorkoutManager())
}
