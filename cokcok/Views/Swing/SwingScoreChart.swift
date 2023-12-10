//
//  SwingScoreChart.swift
//  cokcok
//
//  Created by 최지웅 on 12/10/23.
//

import SwiftUI
import Charts

private struct SwingScoreChartData:Identifiable{
    let id: Int
    let y: Double
}

struct SwingScoreChart: View {
    let scoreList: [Double]
    @Binding var selectedPhase:Int
    private var cumulativeValue:[SwingScoreChartData]{
        var ret:[SwingScoreChartData] = []
        var cum:Int = 1
        scoreList.forEach{ data in
            ret.append(SwingScoreChartData(id: cum, y: data))
            cum += 1
        }
        return ret
    }
    var selectedXmin: Double {
        switch(selectedPhase){
        case 1:
            0
        case 2:
            5.33
        case 3:
            10.66
        default:0
        }
    }
    var selectedXmax: Double {
        switch(selectedPhase){
        case 1:
            5.33
        case 2:
            10.66
        case 3:
            16
        default:0
        }
    }
    let linearGradient = LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.4),.blue.opacity(0)]),startPoint: .top,endPoint: .bottom)
    var body: some View {
        Chart {
            ForEach(cumulativeValue) { data in
                LineMark(x: .value("x", data.id),
                         y: .value("y", data.y))
                .symbol(.circle)
                .foregroundStyle(.blue)
            }
            .interpolationMethod(.catmullRom)
            if(selectedPhase>0){
                AreaMark(xStart: .value("x", selectedXmin), xEnd: .value("x", selectedXmax), y: .value("y", 100))
                    .foregroundStyle(linearGradient)
                AreaMark(xStart: .value("x", selectedXmin), xEnd: .value("x", selectedXmax), y: .value("y", 0))
                    .foregroundStyle(linearGradient)
            }
        }
        .animation(.easeIn, value:selectedPhase)
        .chartYScale(domain:0...100)
        .chartXScale(domain:0...16)
        .chartXAxis(.hidden)
        .chartYAxis{
            AxisMarks(preset:.inset, position:.leading)
        }
        .chartLegend(.hidden)
    }
}

#Preview {
    SwingScoreChart(scoreList: generateNormalDistributionArray(size: 15, mean: 50, standardDeviation: 5), selectedPhase: .constant(0))
}
// 정규 분포를 따르는 난수 생성기
struct GaussianRandomNumberGenerator: RandomNumberGenerator {
    private var rng = SystemRandomNumberGenerator()

    mutating func next() -> UInt64 {
        return UInt64(abs(Int64(bitPattern: rng.next())))
    }
}
// 정규 분포를 갖는 [Double] 배열 생성 함수
func generateNormalDistributionArray(size: Int, mean: Double, standardDeviation: Double) -> [Double] {
    var generator = GaussianRandomNumberGenerator()
    var result = [Double]()

    for _ in 0..<size {
        let u1 = Double.random(in: 0..<1, using: &generator)
        let u2 = Double.random(in: 0..<1, using: &generator)
        let randomNormal = sqrt(-2 * log(u1)) * cos(2 * .pi * u2)

        // 정규 분포의 평균과 표준 편차를 적용하여 값 조정
        let value = mean + standardDeviation * randomNormal
        result.append(value)
    }

    return result
}

