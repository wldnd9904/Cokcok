//
//  MatchItem.swift
//  cokcok
//
//  Created by 최지웅 on 11/7/23.
//

import SwiftUI

struct MatchItem: View {
    @State var extended: Bool = false
    var match: MatchSummary

    var body: some View {
        VStack{
            HStack(alignment:.center) {
                HStack{
                    Image(systemName: "clock")
                        .foregroundColor(.green)
                        .font(.title)
                    Text("\(formatTimeIntervalDuration(match.workout?.duration ?? 0))")
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
                        Text(formatDateString(for: match.workout?.startDate ?? Date()))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            if extended {
                ScoreChart(matchSummary: match)
                    .frame(height:200)
            }
        }
        .frame(maxWidth: .infinity) // 최대 너비 제한
        .padding(15)
        .background(.thinMaterial)
        .cornerRadius(10)
        .onTapGesture {
            withAnimation{
                extended.toggle()
            }
        }
    }
}

#Preview {
    MatchItem(match: generateRandomMatchSummaries(count: 1)[0])
}
