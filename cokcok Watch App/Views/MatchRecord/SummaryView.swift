//
//  SummaryView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI
import HealthKit

struct SummaryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        if workoutManager.state != .ended && workoutManager.state != .saved {
            ProgressView(workoutManager.state.message)
                .navigationBarHidden(true)
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text( "기록 완료")
                        .font(.title2)
                    SummaryMetricView(
                        title: "경기 시간",
                        value: durationFormatter.string(from: workoutManager.matchSummary?.duration ?? 0.0) ?? ""
                    ).accentColor(Color.green)
                    SummaryMetricView(
                        title: "경기 점수",
                        value: "\(workoutManager.matchSummary?.myScore ?? 0) : \(workoutManager.matchSummary?.opponentScore ?? 0)"
                    ).accentColor(.yellow)
                    SummaryMetricView(title: "이동 거리",
                                      value: Measurement(value: workoutManager.matchSummary?.totalDistance ?? 0, unit: UnitLength.meters)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .road,
                                                                numberFormatStyle: .number.precision(.fractionLength(2))))).foregroundStyle(.green)
                    SummaryMetricView(
                        title: "소모 열량",
                        value: Measurement(
                            value: workoutManager.matchSummary?.totalEnergyBurned ?? 0,
                            unit: UnitEnergy.kilocalories
                        ).formatted(
                            .measurement(
                                width: .abbreviated,
                                usage: .workout,
                                numberFormatStyle: .number.precision(.fractionLength(0))
                            )
                        )
                    ).accentColor(Color.pink)
                    SummaryMetricView(
                        title: "평균 심박수",
                        value: (workoutManager.matchSummary?.averageHeartRate ?? 0).formatted(
                                .number.precision(.fractionLength(0))
                            )
                        + " bpm"
                    ).accentColor(Color.red)
                    if(workoutManager.state == .ended){
                        Text("경기가 기록되었습니다. iPhone 콕콕 앱에서 분석 결과를 확인할 수 있습니다.")
                    }else {
                        Text("인터넷이 연결되지 않아 경기가 임시 저장되었습니다. 인터넷이 연결되면 자동으로 iPhone 콕콕 앱에 저장됩니다.")
                    }
                    Button("확인") {
                        dismiss()
                    }
                }
                .scenePadding()
            }
            .navigationTitle("경기 요약")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SummaryView()
        .environmentObject(WorkoutManager())
}

struct SummaryMetricView: View {
    var title: String
    var value: String

    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                    .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        Divider()
    }
}
