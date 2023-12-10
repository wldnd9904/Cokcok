//
//  ScoreGraphView.swift
//  cokcok
//
//  Created by 최지웅 on 11/8/23.
//

import SwiftUI
import Charts

struct SwingTrendChart: View {
    let swings: [SwingAnalyze]
    
    var body: some View {
        Chart {
            ForEach(swings.enumerated().map{($0,$1.swingScore)},id:\.0){
                MyLineMark(x: $0 , y: $1)
            }
        }
        .chartXScale(domain:-1...swings.count)
        .chartYScale(domain: 0...100)
        .chartXAxis {
            AxisMarks() { _ in
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}

#Preview {
    SwingTrendChart(swings:generateRandomSwingData(count: 10))
        .frame(height:200)
}

private struct MyLineMark: ChartContent {
    let x: Int
    let y: Int
    var body: some ChartContent {
        LineMark(
            x:.value("",x),
            y:.value("",y)
        )
        .symbol(Circle().strokeBorder(lineWidth: 3))
        .interpolationMethod(.monotone)
        .lineStyle(StrokeStyle(lineWidth: 3))
        .symbolSize(50)
    }
}
