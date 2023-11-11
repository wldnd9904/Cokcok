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
    func history(_ whose: Character) -> [(x: Int, y:Int)] {
        var sum:Int = 0
        var graph:[(x: Int, y:Int)]  =  matchSummary.history.enumerated().reduce(into:[(    x:0,y:0)]) {
            if $1.element == whose {
                sum += 1
                $0.append((x:$1.offset+1, y:sum))
            }
        }
        graph.append((x:matchSummary.history.count, y:sum))
        return graph
    }
    
    var body: some View {
        Chart{
            ForEach(history("o"), id:\.x) {x,y in
                MyLineMark(x:x, y:y, div: "상대")
            }
            ForEach(history("m"), id:\.x) {x,y in
                MyLineMark(x:x, y:y, div: "나")
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
        .chartXScale(domain: -1...matchSummary.history.count+1)
        .chartYScale(domain: -1...max(matchSummary.myScore , matchSummary.opponentScore)+1)
        .chartXAxis {
            AxisMarks() { _ in
            }
        }
        .chartYAxis{
            AxisMarks(position:.leading)
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
