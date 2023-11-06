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
            Counter(score: $workoutManager.myScore, color: .blue)
            Counter(score: $workoutManager.opponentScore, color:.red)
        }
    }
}

#Preview {
    ScoreView()
        .environmentObject(WorkoutManager())
}
