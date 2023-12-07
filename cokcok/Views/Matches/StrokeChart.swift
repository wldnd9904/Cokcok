//
//  StrokeChart.swift
//  cokcok
//
//  Created by 최지웅 on 12/7/23.
//

import SwiftUI
import Charts


struct StrokeChart: View {
    let swings: [Swing]
    @Binding var selectedSwing: SwingType?
    var body: some View {
        Chart{
            ForEach(swings, id: \.id) { swing in 
                LineMark(x:.value("index",swing.id),
                    y:.value("score",swing.score))
            }
            .interpolationMethod(.catmullRom)
            .symbol(.circle)
            .symbolSize(50)
            
            ForEach(swings, id: \.id) { swing in
                PointMark(x: .value("index",swing.id), y:.value("score", swing.score))
                    .annotation(position: .top){
                        Text("\(swing.score)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .opacity(swing.type == selectedSwing ? 1.0 : 0.0)
                            .animation(.easeInOut, value: selectedSwing)
                    }
                    .symbol {
                            Circle()
                                .foregroundStyle(swing.type.color)
                                .opacity(swing.type == selectedSwing ? 1.0 : 0.0)
                                .animation(.easeInOut, value: selectedSwing)
                                .frame(width:10)
                    }
            }

        }
        .chartYScale(domain: -1...101)
        .chartYAxis{
            AxisMarks(position:.leading)
        }
        .chartXAxis(.hidden)
        .chartLegend(.hidden)
    }
}

#Preview {
    StrokeChart(swings: generateRandomSwings(count: 20), selectedSwing: .constant(.bu))
}
