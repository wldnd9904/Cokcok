//
//  SwingAnalyze.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Foundation

public struct SwingAnalyze:Identifiable {
    public var id: UUID
    var score:Int
    var date: Date
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
