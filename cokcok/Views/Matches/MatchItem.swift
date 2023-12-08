//
//  MatchItem.swift
//  cokcok
//
//  Created by 최지웅 on 11/7/23.
//

import SwiftUI

struct MatchItem: View {
    let match: MatchSummary
    let score: Double = Double(Int.random(in: 0...1000))/10
    var body: some View {
        HStack(alignment:.center) {
            HStack{
                Text("\(String(format:"%.1f",score))")
                    .bold()
                    .foregroundStyle(.green)
                    .font(.title)
                Text("점")
                    .bold()
                    .foregroundStyle(.gray)
                Spacer()
                Text("\(match.myScore)")
                    .fontWeight(match.myScore >= match.opponentScore ? .bold : nil)
                    .foregroundStyle(.blue)
                    .font(.title)
            }
            HStack{
                Text(":")
                    .font(.title)
                    .foregroundStyle(.black)
            }
            HStack{
                Text("\(match.opponentScore)")
                    .fontWeight(match.opponentScore >= match.myScore ? .bold : nil)
                    .foregroundStyle(.red)
                    .font(.title)
                Spacer()
                    Text(formatDateString(for: match.startDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity) // 최대 너비 제한
        .padding(15)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    MatchItem(match: generateRandomMatchSummaries(count: 1)[0])
}
