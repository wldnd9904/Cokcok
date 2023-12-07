//
//  MatchDetail.swift
//  cokcok
//
//  Created by 최지웅 on 11/8/23.
//

import SwiftUI

struct MatchDetail: View {
    let match: MatchSummary
    @State var selectedSwing: SwingType? = nil
    
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
                        .fontWeight(match.myScore<=match.opponentScore ? .bold : nil)
                }
                ScoreChart(matchSummary: match)
                    .frame(height:200)
            }
            Section(header:Text("스윙 통계").font(.title2).foregroundStyle(.primary).bold()){
                ScrollView(.horizontal, showsIndicators: false){
                    StrokeChart(swings: match.swingList, selectedSwing: $selectedSwing)
                        .frame(width:(500+CGFloat(match.swingList.count)*5),height:200)
                        .padding(.vertical,20)
                }
                
                HStack{
                    StrokeItem(selectedSwing: $selectedSwing, type: .fh, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .fu, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .fd, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .fs, swingList: match.swingList)
                }
                HStack{
                    StrokeItem(selectedSwing: $selectedSwing, type: .bh, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .bu, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .bd, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .fp, swingList: match.swingList)
                }
                HStack{
                    StrokeItem(selectedSwing: $selectedSwing, type: .fn, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .bn, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .ss, swingList: match.swingList)
                    Spacer()
                    StrokeItem(selectedSwing: $selectedSwing, type: .ls, swingList: match.swingList)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private struct StrokeItem: View {
        @Binding var selectedSwing: SwingType?
        let type: SwingType
        let swingList: [Swing]
        var filteredSwingList: [Swing] {
            swingList.filter{$0.type == type}
        }
        var avgScore: Double {
            if filteredSwingList.count == 0 {0}            else {
                Double(filteredSwingList.reduce(0){$0 + $1.score
                })/Double(filteredSwingList.count)
            }
        }
        
        var body: some View {
            VStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(type.color, lineWidth: 3)
                            .frame(width: 60, height: 60)
                    )
                    .overlay{
                        if selectedSwing == type {
                            Text(String(format:"%.1f", avgScore))
                                .font(.title2)+Text("점").font(.subheadline)
                        } else {
                            Text("\(filteredSwingList.count)")
                                .font(.title)+Text("회").font(.subheadline)
                        }
                    }
                    .foregroundColor(type.color)
                Text(type.rawValue)
                    .font(.caption)
            }
            .onTapGesture {
                if(selectedSwing == type){
                    withAnimation{
                        selectedSwing = nil
                    }
                }else {
                    withAnimation{
                        selectedSwing = type
                    }
                }
            }
        }
    }
}

private struct DetailItem: View {
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

#Preview {
    MatchDetail(match:generateRandomMatchSummaries(count: 1)[0])
}




/*
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(type.rawValue)
                    .bold()
                HStack{
                    Text(String(format:"%.1f",avgScore))
                        .font(.system(.title2, design: .rounded)
                        )+Text("점")
                    Text("/")
                    Text("\(filteredSwingList.count)")
                        .font(.system(.title2, design: .rounded))+Text("회")
                }.foregroundStyle(color)
            }
            Spacer()
        }
    }
*/
