//
//  Achievement.swift
//  cokcok
//
//  Created by 최지웅 on 11/23/23.
//

import Foundation


struct AchievementType: Identifiable {
    let id:Int
    let name: String
    let unit: String
    let DMin: Int
    let CMin: Int
    let BMin: Int
    let AMin: Int
    let SMin: Int
    let icon: String
}

struct UserAchievement: Identifiable {
    let id: Int
    let type: AchievementType
    let month: Date?
    var currentCnt: Int
    var DDate: Date?
    var CDate: Date?
    var BDate: Date?
    var ADate: Date?
    var SDate: Date?
}


func randomDate() -> Date? {
    let startDate = Date(timeIntervalSinceNow: -730 * 24 * 60 * 60) // 2 years ago
    let randomInterval = TimeInterval(arc4random_uniform(UInt32(730 * 24 * 60 * 60)))
    return Date(timeInterval: randomInterval, since: startDate)
}
let nameOptions = ["경기 횟수", "경기 일수", "스윙 횟수", "하이클리어 수", "소모 칼로리"]
let unitOptions = ["회", "일", "회", "회", "kcal"]
let symbolOptions = ["play.circle", "play.circle", "figure.squash", "figure.badminton", "flame"]
let amplifierOptions = [10, 6, 20, 10, 500]

func generateDemoAchievementTypes() -> [AchievementType] {
    var achievementTypes: [AchievementType] = []
    for i in 0..<nameOptions.count {
        let achievementType = AchievementType(
            id: i,
            name: nameOptions[i],
            unit: unitOptions[i],
            DMin: amplifierOptions[i]*1,
            CMin: amplifierOptions[i]*2,
            BMin: amplifierOptions[i]*3,
            AMin: amplifierOptions[i]*4,
            SMin: amplifierOptions[i]*5,
            icon: symbolOptions[i]
        )
        achievementTypes.append(achievementType)
    }
    return achievementTypes
}


func generateRandomUserAchievements(cnt: Int) -> [UserAchievement] {
    let achievementTypes = generateDemoAchievementTypes()
    var userAchievements: [UserAchievement] = []

    for i in 0...cnt {
        let type = achievementTypes[Int.random(in: 0..<achievementTypes.count)]
        
        
        var userAchievement = UserAchievement(
            id: i,
            type: type,
            month: Double.random(in: 0...1)<0.7 ? randomDate() : nil,
            currentCnt: Int.random(in: 0...Int(Double(type.SMin) * 1.2))
        )
        userAchievement.DDate = userAchievement.currentCnt >= type.DMin ? randomDate() : nil
        userAchievement.CDate = userAchievement.currentCnt >= type.CMin ? randomDate() : nil
        userAchievement.BDate = userAchievement.currentCnt >= type.BMin ? randomDate() : nil
        userAchievement.ADate = userAchievement.currentCnt >= type.AMin ? randomDate() : nil
        userAchievement.SDate = userAchievement.currentCnt >= type.SMin ? randomDate() : nil

        userAchievements.append(userAchievement)
    }

    return userAchievements
}
