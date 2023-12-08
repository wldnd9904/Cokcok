//
//  SummaryRow.swift
//  cokcok
//
//  Created by 최지웅 on 12/8/23.
//

import SwiftUI

struct SummaryRow: View {
    let matches: [MatchSummary]
    @Binding var selectedSummaryType: SummaryType
    var columns = GridItem(.adaptive(minimum: 180, maximum: 300), spacing: 8)
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack{
                GroupBox(label: Label("경기 수", systemImage: "play.circle")
                    .frame(height:30)) {
                    SummaryValueView(value: "\(matches.count)", unit: "회")
                    }.groupBoxStyle(SummaryGroupBoxStyle(color: .orange){
                        withAnimation{
                            selectedSummaryType = .matchCount
                        }
                    })
                
                GroupBox(label: Label("승률", systemImage: "figure.dance")
                    .frame(height:30)) {
                        SummaryValueView(value:matches.count == 0 ? "0" :  "\(String(format:"%.1f",Double(matches.reduce(0){$1.myScore > $1.opponentScore ? $0 + 1 : $0})/Double(matches.count)*100))", unit: "%")
                    }.groupBoxStyle(SummaryGroupBoxStyle(color: .pink){
                        withAnimation{
                            selectedSummaryType = .winPortion}})
                
                GroupBox(label: Label("이동 거리", systemImage: "figure.run")
                    .frame(height:30)) {
                        SummaryValueView(value: "\(String(format:"%.1f",matches.reduce(0.0){$0+$1.totalDistance}/1000))", unit: "KM")
                    }.groupBoxStyle(SummaryGroupBoxStyle(color: .blue){
                        withAnimation{
                            selectedSummaryType = .distance}})
                
                GroupBox(label: Label("경기 시간", systemImage: "stopwatch")
                    .frame(height:30)) {
                        SummaryValueView(value: "\(String(format:"%.1f",matches.reduce(0.0){$0+$1.duration}/3600))", unit: "시간")
                    }.groupBoxStyle(SummaryGroupBoxStyle(color: .green){
                        withAnimation{
                            selectedSummaryType = .time}})
                
                GroupBox(label: Label("스윙 수", systemImage: "figure.badminton")
                    .frame(height:30)) {
                        SummaryValueView(value: "\(matches.reduce(0){$0+$1.swingList.count})", unit: "회")
                    }.groupBoxStyle(SummaryGroupBoxStyle(color: .orange){
                        withAnimation{
                            selectedSummaryType = .swings}})
            }
        }
        .cornerRadius(10)
    }
}
private struct SummaryValueView: View {
    var value: String
    var unit: String
    
    @ScaledMetric var size: CGFloat = 1
    
    @ViewBuilder var body: some View {
        HStack {
            Text(value).font(.system(size: 24 * size, weight: .bold, design: .rounded)) + Text(" \(unit)").font(.system(size: 14 * size, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
            Spacer()
        }
    }
}


#Preview {
    NavigationStack{
        SummaryRow(matches: generateRandomMatchSummaries(count: 300), selectedSummaryType: .constant(.swings))
            .frame(height:200)
            .background(Color(.systemGroupedBackground))
    }
}
