//
//  Matches.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import SwiftUI

struct Matches: View {
    // 예시로 10개의 MatchSummary를 생성
    let randomMatchSummaries = generateRandomMatchSummaries(count: 10)
    
    var body: some View {
        ScrollView{
            ForEach(randomMatchSummaries.sorted{$0.workout!.startDate > $1.workout!.startDate}, id: \.workout.hashValue) { match in
                MatchItem(match: match)
                    .padding(.horizontal,5)
            }
        }
    }
}

#Preview {
    Matches()
}
