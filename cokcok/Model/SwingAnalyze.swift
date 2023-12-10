//
//  SwingAnalyze.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Foundation

public struct SwingAnalyze:Identifiable, Codable {
    public let id: Int
    let videoUrl: URL
    let poseStrength: String
    let poseWeakness: String
    let wristPrepareStrength: String
    let wristImpactStrength: String
    let wristFollowStrength: String
    let wristPrepareWeakness: String
    let wristImpactWeakness: String
    let wristFollowWeakness: String
    let recordDate: Date
    let swingScore: Int
    let swingScoreList: [Double]
    let resPrepare: Double
    let resImpact: Double
    let resFollow: Double
    let wristMaxAcceleration: Double
}

func generateRandomSwingData(count: Int) -> [SwingAnalyze] {
    var swingList: [SwingAnalyze] = []

    let currentDate = Date()
    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)!

    for i in 0..<count {
        let randomScore = Int.random(in: 0...100)
        let randomDate = Date(timeInterval: TimeInterval.random(in: thirtyDaysAgo.timeIntervalSinceNow...currentDate.timeIntervalSinceNow), since: currentDate)
        let swing = SwingAnalyze(id: i, videoUrl: URL(string:"https://cokcok.s3.ap-northeast-2.amazonaws.com/videos/2023-12-10%2016%3A31%3A11_f.mp4")!, poseStrength: "", poseWeakness: "", wristPrepareStrength: "", wristImpactStrength: "", wristFollowStrength: "", wristPrepareWeakness: "", wristImpactWeakness: "", wristFollowWeakness: "", recordDate: randomDate, swingScore: randomScore, swingScoreList: generateNormalDistributionArray(size: 15, mean: 50, standardDeviation: 20), resPrepare: 50, resImpact: 60, resFollow: 70, wristMaxAcceleration: 21.5)
        swingList.append(swing)
    }

    return swingList.sorted { $0.recordDate < $1.recordDate }
}
