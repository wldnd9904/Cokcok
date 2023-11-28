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
        ScrollView(showsIndicators: false){
            ForEach(randomMatchSummaries.sorted{$0.startDate > $1.startDate}, id: \.id) { match in
                NavigationLink(destination: MatchDetail(match:match).navigationTitle(formatDateWithDay(match.startDate))){
                    MatchItem(match: match)
                        .padding(.horizontal,5)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    NavigationStack{
        Matches()
    }
}
