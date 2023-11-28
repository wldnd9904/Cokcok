//
//  MatchItem.swift
//  cokcok
//
//  Created by 최지웅 on 11/7/23.
//

import SwiftUI

struct MatchItem: View {
    let match: MatchSummary

    var body: some View {
        HStack(alignment:.center) {
            HStack{
                Image(systemName: "clock")
                    .foregroundColor(.green)
                    .font(.title)
                Text("\(formatTimeIntervalDuration(match.duration))")
                    .font(.system(.title, design: .rounded, weight: .bold)).foregroundStyle(.green)
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
                VStack(alignment: .trailing){
                    HStack{
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                        Text("\(String(format: "%.0f", match.averageHeartRate)) BPM")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    Text(formatDateString(for: match.startDate))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
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
