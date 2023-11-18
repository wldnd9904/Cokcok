//
//  MatchDetail.swift
//  cokcok
//
//  Created by 최지웅 on 11/8/23.
//

import SwiftUI

struct MatchDetail: View {
    let match: MatchSummary
    
    var body: some View {
        List {
            Section(header:Text("운동 세부사항").font(.title2).foregroundStyle(.primary).bold()){
                HStack() {
                    DetailItem(title: "운동 시간", value:formatTimeIntervalDuration(match.duration, showseconds:true))
                            .accentColor(.green)
                    DetailItem(title: "이동 거리", value: Measurement(value: match.totalDistance,
                                                   unit: UnitLength.meters)
                                  .formatted(.measurement(width: .abbreviated,
                                                          usage: .road,
                                                          numberFormatStyle: .number.precision(.fractionLength(2)))))
                        .accentColor(.blue)
                }
                HStack() {
                    DetailItem(title: "평균 심박수", value: match.averageHeartRate
                        .formatted(
                            .number.precision(.fractionLength(0))
                        ) + " bpm")
                        .accentColor(.red)
                    DetailItem(title: "총 킬로칼로리", value:Measurement(
                        value: match.totalEnergyBurned,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout,
                            numberFormatStyle: .number.precision(.fractionLength(0))
                        )
                    ))
                        .accentColor(.red)
                }
            }
            Section(header:Text("경기 통계").font(.title2).foregroundStyle(.primary).bold()){
                HStack() {
                    DetailItem(title: "내 점수", value: "\(match.myScore)")
                            .accentColor(.blue)
                            .fontWeight(match.myScore>=match.opponentScore ? .bold : nil)
                    DetailItem(title: "상대 점수", value: "\(match.opponentScore)")
                        .accentColor(.red)
                        .fontWeight(match.myScore>=match.opponentScore ? nil : .bold)
                }
                HStack() {
                    Spacer()
                    StrokeItem(number: 11, name: "포어헤드 언더", color: .blue)
                    Spacer()
                    StrokeItem(number: 25, name: "포어핸드 하이", color: .green)
                    Spacer()
                    StrokeItem(number: 4, name: "스매시", color: .red)
                    Spacer()
                }
                HStack {
                    Spacer()
                    StrokeItem(number: 19, name: "백핸드 언더", color: .yellow)
                    Spacer()
                    StrokeItem(number: 1, name: "백핸드 하이", color: .orange)
                    Spacer()
                }
            }
            Section(header:Text("경기 히스토리").font(.title2).foregroundStyle(.primary).bold()){
                ScoreChart(matchSummary: match)
                    .frame(height:200)
            }
        }
    }
}

struct DetailItem: View {
    var title: String
    var value: String

    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .bold()
                Text(value)
                    .font(.system(.title2, design: .rounded)
                        .lowercaseSmallCaps()
                    )
                    .foregroundColor(.accentColor)
            }
            Spacer()
        }
    }
}

private struct StrokeItem: View {
    var number: Int
    var name: String
    var color: Color
    
    var body: some View {
        VStack {
            Circle()
                .fill(Color.white)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(color, lineWidth: 3)
                        .frame(width: 60, height: 60)
                )
                .overlay(
                    Text("\(number)")
                        .font(.title)
                        .foregroundColor(color)
                )
            Text(name)
                .font(.caption)
        }.frame(width:100)
    }
}

#Preview {
    MatchDetail(match:generateRandomMatchSummaries(count: 1)[0])
}

