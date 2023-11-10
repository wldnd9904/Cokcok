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
            Counter2(score: workoutManager.matchSummary?.myScore ?? 0, color: .blue, incrementVar: {
                workoutManager.matchSummary?.addScore(player: .me)
            }, decrementVar: {
                workoutManager.matchSummary?.removeScore(player: .me)
            }, resetVar: {
                workoutManager.matchSummary?.resetScore(player: .me)
            })
            Counter2(score: workoutManager.matchSummary?.opponentScore ?? 0, color: .red, incrementVar: {
                workoutManager.matchSummary?.addScore(player: .opponent)
            }, decrementVar: {
                workoutManager.matchSummary?.removeScore(player: .opponent)
            }, resetVar: {
                workoutManager.matchSummary?.resetScore(player: .opponent)
            })
        }
    }
}

#Preview {
    ScoreView()
        .environmentObject(WorkoutManager())
}
