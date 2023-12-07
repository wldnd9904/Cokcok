//
//  SwingAnalyze.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Foundation

public struct SwingAnalyze:Identifiable, Codable {
    public let id: Int
    let totalScore:Int
    let date: Date
    let timeStampScore: [Int] // 시점별 점수
    let videoURL: URL
    let power: Double // 타점의 가속도
    let poseStrength: String
    let poseWeakness: String
    let wristStrength: String
    let wristWeakness: String
    
    //스코어, 맥스
    //타임스탬프별 오차
    //타점인덱스는 16
    //그래프에서 x가 타임스탬프, y가 점수
    //8 ~ 22가 유효구간
}

func generateRandomSwingData(count: Int) -> [SwingAnalyze] {
    var swingList: [SwingAnalyze] = []

    let currentDate = Date()
    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: currentDate)!

    for _ in 0..<count {
        let randomScore = Int.random(in: 0...100)
        let randomDate = Date(timeInterval: TimeInterval.random(in: thirtyDaysAgo.timeIntervalSinceNow...currentDate.timeIntervalSinceNow), since: currentDate)

        let swing = SwingAnalyze(id: UUID(), score: randomScore, date: randomDate)
        swingList.append(swing)
    }

    return swingList.sorted { $0.date < $1.date }
}
