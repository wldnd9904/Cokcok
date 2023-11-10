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
        if workoutManager.matchSummary == nil {
            ProgressView("경기를 기록하는 중...")
                .navigationBarHidden(true)
        } else {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Text("승리!")
                        .font(.title)
                    SummaryMetricView(
                        title: "경기 시간",
                        value: durationFormatter.string(from: workoutManager.matchSummary?.workout?.duration ?? 0.0) ?? ""
                    ).accentColor(Color.green)
                    SummaryMetricView(
                        title: "경기 점수",
                        value: "\(workoutManager.matchSummary?.myScore ?? 0) : \(workoutManager.matchSummary?.opponentScore ?? 0)"
                    ).accentColor(.yellow)
                    SummaryMetricView(title: "이동 거리",
                                      value: Measurement(value: workoutManager.matchSummary?.workout?.totalDistance?.doubleValue(for: .meter()) ?? 0,
                                                         unit: UnitLength.meters)
                                        .formatted(.measurement(width: .abbreviated,
                                                                usage: .road,
                                                                numberFormatStyle: .number.precision(.fractionLength(2)))))
                        .foregroundStyle(.green)
                    SummaryMetricView(
                        title: "소모 열량",
                        value: Measurement(
                            value: workoutManager.matchSummary?.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
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
                    Text("Activity Rings")
                    ActivityRingsView(
                        healthStore: workoutManager.healthStore
                    ).frame(width: 50, height: 50)
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
