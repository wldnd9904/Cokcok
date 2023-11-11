//
//  ScoreView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var body: some View {
        HStack{
            Counter2(score: workoutManager.matchSummary?.myScore ?? 0, color: .blue
            ,incrementVar: {
                if workoutManager.state == .running {
                    workoutManager.matchSummary?.addScore(player: .me)
                }
            }, decrementVar: {
                if workoutManager.state == .running {
                    workoutManager.matchSummary?.removeScore(player: .me)
                }
            }, resetVar: nil)
            Counter2(score: workoutManager.matchSummary?.opponentScore ?? 0, color: .red
            , incrementVar: {
                if workoutManager.state == .running {
                    workoutManager.matchSummary?.addScore(player: .opponent)
                }
            }, decrementVar: {
                if workoutManager.state == .running {
                    workoutManager.matchSummary?.removeScore(player: .opponent)
                }
            }, resetVar: nil)
        }
    }
}

#Preview {
    ScoreView()
        .environmentObject(WorkoutManager())
}
