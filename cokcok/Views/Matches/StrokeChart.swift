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
                if(swing.type == .x) {
                    PointMark(x:.value("index",swing.id),
                              y:.value("score",swing.score))
                    .symbol{
                        Image(systemName: "xmark")
                            .foregroundStyle(.red)
                            .bold()
                    }
                }
            }
            ForEach(swings, id: \.id) { swing in
                if(swing.type != .x) {
                    LineMark(x:.value("index",swing.id),
                             y:.value("score",swing.score))
                    .symbol(.circle)
                }
            }
            .interpolationMethod(.catmullRom)
            .symbolSize(50)
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.gray]),startPoint: .top,
                                      endPoint: .bottom))
            
            ForEach(swings, id: \.id) { swing in
                if(swing.type != .x){
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
                                .stroke(swing.type.color, lineWidth:3)
                                .foregroundStyle(swing.type.color)
                                .scaleEffect(swing.type == selectedSwing ? 1.2 : 0.6)
                                .animation(.easeInOut, value: selectedSwing)
                                .frame(width:10)
                        }
                }
            }
        }
        .chartXScale(domain:1...swings.count+1)
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
