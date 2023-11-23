//
//  Achievement.swift
//  cokcok
//
//  Created by 최지웅 on 11/23/23.
//

import Foundation

struct Achievement: Identifiable {
    let id: Int
    let month: Date?
    let name: String
    let symbol: String
    let unit: String
    var isNew: Bool
    var currentCnt: Int
    var ACnt: Int
    var ADate: Date?
    var BCnt: Int
    var BDate: Date?
    var CCnt: Int
    var CDate: Date?
    var DCnt: Int
    var DDate: Date?
    var ECnt: Int
    var EDate: Date?
}

func randomDate() -> Date? {
    let startDate = Date(timeIntervalSinceNow: -730 * 24 * 60 * 60) // 2 years ago
    let randomInterval = TimeInterval(arc4random_uniform(UInt32(730 * 24 * 60 * 60)))
    return Date(timeInterval: randomInterval, since: startDate)
}

func randomAchievement() -> Achievement {
    let id = AchievementCounter.nextId()
    let nameOptions = ["경기 횟수", "경기 일수", "스윙 횟수", "하이클리어 수", "소모 칼로리"]
    let unitOptions = ["회", "일", "회", "회", "kcal"]
    let symbolOptions = ["play.circle","play.circle","figure.squash" ,"figure.badminton", "flame" ]
    let amplifierOptions = [10, 6, 20, 10, 500]

    let nameIndex = Int(arc4random_uniform(UInt32(nameOptions.count)))

    let name = nameOptions[nameIndex]
    let unit = unitOptions[nameIndex]
    let symbol = symbolOptions[nameIndex]

    let month = arc4random_uniform(2) == 0 ? nil : randomDate()

    var cntValues = [Int]()
    for i in 1...5 {
        cntValues.append(i*amplifierOptions[nameIndex])
    }

    let currentCnt = Int.random(in: 0...6*amplifierOptions[nameIndex])
    let ACnt = cntValues[4]
    let BCnt = cntValues[3]
    let CCnt = cntValues[2]
    let DCnt = cntValues[1]
    let ECnt = cntValues[0]

    return Achievement(
        id: id,
        month: month,
        name: name,
        symbol: symbol,
        unit: unit,
        isNew: false,
        currentCnt: currentCnt,
        ACnt: ACnt,
        ADate: randomDate(),
        BCnt: BCnt,
        BDate: randomDate(),
        CCnt: CCnt,
        CDate: randomDate(),
        DCnt: DCnt,
        DDate: randomDate(),
        ECnt: ECnt,
        EDate: randomDate()
    )
}

struct AchievementCounter {
    private static var counter = 0

    static func nextId() -> Int {
        counter += 1
        return counter
    }
}

func generateRandomAchievements(count: Int) -> [Achievement] {
    var achievements = [Achievement]()
    for i in 1...count {
        var achievement = randomAchievement()
        if i < count/2 {
            achievement.isNew = true
        }
        achievements.append(achievement)
    }
    return achievements
}
