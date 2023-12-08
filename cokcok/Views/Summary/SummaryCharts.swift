//
//  PieChart.swift
//  cokcok
//
//  Created by 최지웅 on 12/8/23.
//

import SwiftUI
import Charts

enum SummaryType: String{
    case matchCount="경기 수", winPortion="승률", distance="이동 거리", time="경기 시간", swings="스윙 수"
}

struct SummaryCharts: View {
    let matches: [MatchSummary]
    @Binding var selectedSummaryType: SummaryType
    var body: some View {
        VStack{
                Text(selectedSummaryType.rawValue)
                    .font(.title2)
                    .bold()
                    .padding()
            switch(selectedSummaryType){
            case .matchCount:
                MatchCountChart(matches:matches)
            case .distance:
                DistanceChart(matches:matches)
            case .time:
                TimeChart(matches:matches)
            case .winPortion:
                if #available(iOS 17.0, *) {
                    WinPortionChart(matches: matches)
                } else {
                    Text("현재 iOS버전에서 표시할 수 없습니다.")
                        .padding()
                }
            case .swings:
                if #available(iOS 17.0, *) {
                    SwingChart(matches: matches)
                } else {
                    Text("현재 iOS버전에서 표시할 수 없습니다.")
                        .padding()
                }
            }
        }
    }
    

}

struct ChartData: Identifiable, Equatable {
    let type: String
    let id: Int
    let y: Int
}


struct ChartDoubleData: Identifiable, Equatable {
    let type: String
    let id: Int
    let y: Double
}

struct MatchCountChart: View {
    let matches: [MatchSummary]
    let today=Calendar.current.component(.day, from:Date())
    var cumulativeValue:[ChartData]{
        var ret:[ChartData] = []
        var zeroArray = Array(repeating: 0, count: 31)
        matches.forEach{
            zeroArray[Calendar.current.component(.day, from: $0.startDate)] += 1
        }
        var curVal = 0
        for i in 1...today {
            curVal += zeroArray[i]
            ret.append(ChartData(type: "count", id: i, y: curVal))
        }
        return ret
    }
    let linearGradient = LinearGradient(gradient: Gradient(colors: [.orange.opacity(0.4),.orange.opacity(0)]),startPoint: .top,endPoint: .bottom)
    var body: some View {
        Chart {
            ForEach(cumulativeValue) { data in
                LineMark(x: .value("x", data.id),
                         y: .value("y", data.y))
                .symbol(.circle)
                .foregroundStyle(.orange)
            }
            .interpolationMethod(.cardinal)
            ForEach(cumulativeValue) { data in
                AreaMark(x: .value("x", data.id),
                         y: .value("y", data.y))
            }
            .interpolationMethod(.cardinal)
            .foregroundStyle(linearGradient)
        }
        .chartXScale(domain:1...today)
        .chartXAxisLabel("일")
        .chartYAxisLabel("회")
        .chartLegend(.hidden)
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}


struct DistanceChart: View {
    let matches: [MatchSummary]
    let today=Calendar.current.component(.day, from:Date())
    var cumulativeValue:[ChartDoubleData]{
        var ret:[ChartDoubleData] = []
        var zeroArray = Array(repeating: 0.0, count: 31)
        matches.forEach{
            zeroArray[Calendar.current.component(.day, from: $0.startDate)] += $0.totalDistance/1000
        }
        var curVal = 0.0
        for i in 1...today {
            curVal += zeroArray[i]
            ret.append(ChartDoubleData(type: "count", id: i, y: curVal))
        }
        return ret
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
            .interpolationMethod(.cardinal)
            ForEach(cumulativeValue) { data in
                AreaMark(x: .value("x", data.id),
                         y: .value("y", data.y))
            }
            .interpolationMethod(.cardinal)
            .foregroundStyle(linearGradient)
        }
        .chartXScale(domain:1...today)
        .chartXAxisLabel("일")
        .chartYAxisLabel("KM")
        .chartLegend(.hidden)
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

struct TimeChart: View {
    let matches: [MatchSummary]
    let today=Calendar.current.component(.day, from:Date())
    var cumulativeValue:[ChartDoubleData]{
        var ret:[ChartDoubleData] = []
        var zeroArray = Array(repeating: 0.0, count: 31)
        matches.forEach{
            zeroArray[Calendar.current.component(.day, from: $0.startDate)] += $0.duration/3600
        }
        var curVal = 0.0
        for i in 1...today {
            curVal += zeroArray[i]
            ret.append(ChartDoubleData(type: "count", id: i, y: curVal))
        }
        return ret
    }
    let linearGradient = LinearGradient(gradient: Gradient(colors: [.green.opacity(0.4),.green.opacity(0)]),startPoint: .top,endPoint: .bottom)
    var body: some View {
        Chart {
            ForEach(cumulativeValue) { data in
                LineMark(x: .value("x", data.id),
                         y: .value("y", data.y))
                .symbol(.circle)
                .foregroundStyle(.green)
            }
            .interpolationMethod(.cardinal)
            ForEach(cumulativeValue) { data in
                AreaMark(x: .value("x", data.id),
                         y: .value("y", data.y))
            }
            .interpolationMethod(.cardinal)
            .foregroundStyle(linearGradient)
        }
        .chartXScale(domain:1...today)
        .chartXAxisLabel("일")
        .chartYAxisLabel("시간")
        .chartLegend(.hidden)
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }
}

@available(iOS 17.0, *)
struct SwingChart: View {
    let matches: [MatchSummary]
    var body: some View {
        Chart {
            ForEach(SwingType.allCases, id:\.self){
                swingType in
                SectorMark(angle: .value("Type", matches.reduce(0){$0+$1.swingList.filter{$0.type == swingType}.count}),
                           innerRadius: .ratio(0.4),
                           angularInset: 1.5)
                .foregroundStyle(swingType.color)
                .cornerRadius(5)
                .annotation(position: .overlay){
                    VStack{
                        Text(swingType.rawValue)
                        Text("\(matches.reduce(0){$0+$1.swingList.filter{$0.type == swingType}.count})회")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                }
            }
        }
        .frame(height: 300)
        .padding(20)
    }
}

@available(iOS 17.0, *)
struct WinPortionChart: View {
    let matches: [MatchSummary]
    var win: Int {
        matches.filter{$0.myScore > $0.opponentScore}.count
    }
    var lose: Int {
        matches.filter{$0.myScore < $0.opponentScore}.count
    }
    var draw: Int {
        matches.filter{$0.myScore == $0.opponentScore}.count
    }
    var body: some View {
        Chart {
            SectorMark(angle: .value("Type", win),
                       innerRadius: .ratio(0.5),
                       angularInset: 1.5)
            .foregroundStyle(.blue)
            .cornerRadius(5)
            .annotation(position: .overlay){
                Text("\(win)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            SectorMark(angle: .value("Type", lose),
                       innerRadius: .ratio(0.5),
                       angularInset: 1.5)
            .foregroundStyle(.red)
            .annotation(position: .overlay){
                Text("\(lose)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .cornerRadius(5)
            SectorMark(angle: .value("Type", draw),
                       innerRadius: .ratio(0.5),
                       angularInset: 1.5)
            .foregroundStyle(.green)
            .annotation(position: .overlay){
                Text("\(draw)")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .cornerRadius(5)
        }
        .frame(height: 300)
        .padding(20)
        .overlay{
            VStack{
                HStack{
                    Circle().frame(width:10)
                        .foregroundStyle(.blue)
                    Text("승리: \(win)회")
                }
                HStack{
                    Circle().frame(width:10)
                        .foregroundStyle(.red)
                    Text("패배: \(lose)회")
                }
                HStack{
                    Circle().frame(width:10)
                        .foregroundStyle(.green)
                    Text("무승부: \(draw)회")
                }
            }
            .font(.headline)
            .bold()
        }
    }
}
#Preview {
    SummaryCharts(matches: generateRandomMatchSummaries(count: 300), selectedSummaryType: .constant(.matchCount))
}
