//
//  ScoreGraphView.swift
//  cokcok
//
//  Created by 최지웅 on 11/8/23.
//

import SwiftUI
import Charts

struct ScoreChart: View {
    let matchSummary: MatchSummary
    @State var myHistory: [(x: Int, y:Int)] = [(0,0)]
    @State var opponentHistory: [(x: Int, y:Int)] = [(0,0)]
    
    var body: some View {
        Chart{
            ForEach(myHistory, id:\.x) {x,y in
                MyLineMark(x:x, y:y, div: "나")
            }
            ForEach(opponentHistory, id:\.x) {x,y in
                MyLineMark(x:x, y:y, div: "상대")
            }
        }
        .chartForegroundStyleScale([
            "나": .blue,
            "상대": .red
        ])
        .chartSymbolScale([
            "나":Circle().strokeBorder(lineWidth: 3),
            "상대": Circle().strokeBorder(lineWidth: 3)
        ])
        .chartXScale(domain: -1...max(myHistory.last?.x ?? 0, opponentHistory.last?.x ?? 0)+1)
        .chartYScale(domain: -1...max(myHistory.last?.y ?? 0, opponentHistory.last?.y ?? 0)+1)
        .chartXAxis {
            AxisMarks() { _ in
            }
        }
        .chartYAxis{
            AxisMarks(position:.leading)
        }
        .onAppear{
            matchSummary.getHistory(myHistory: &myHistory, opponentHistory: &opponentHistory)
        }
    }
}

#Preview {
    ScoreChart(matchSummary: generateRandomMatchSummaries(count: 1)[0])
        .frame(height:200)
}

struct MyLineMark: ChartContent {
    let x: Int
    let y: Int
    let div: String
    var body: some ChartContent {
        LineMark(
            x:.value("",x),
            y:.value("",y)
        )
        .foregroundStyle(by:.value("구분",div))
        .symbol(by:.value("구분",div))
        .interpolationMethod(.linear)
        .lineStyle(StrokeStyle(lineWidth: 3))
        .symbolSize(50)
    }
}
