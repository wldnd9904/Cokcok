//
//  MatchSummary.swift
//  cokcok
//
//  Created by 최지웅 on 11/7/23.
//

import Foundation
import HealthKit
import SwiftUI

enum Player {
    case me, opponent
}
enum SwingType: String, Codable, CaseIterable {
    case fd = "드라이브"
    case fh = "하이클리어"
    case fp = "드롭"
    case fu = "언더클리어"
    case fn = "헤어핀"
    case fs = "스매시"
    case bd = "백드라이브"
    case bh = "백하이클리어"
    case bu = "백언더클리어"
    case bn = "백헤어핀"
    case ls = "롱 서비스"
    case ss = "숏 서비스"
    
    var color : Color {
        switch(self){
        case .fh:  Color("#45aaf2")
        case .fu:  Color("#26de81")
        case .fd:  Color("#fd9644")
        case .fs:  Color("#fc5c65")
        case .bh: Color("#2d98da")
        case .bu: Color("#20bf6b")
        case .bd: Color("#fa8231")
        case .fp:  Color("#eb3b5a")
        case .fn:  Color("#8854d0")
        case .bn:  Color("#a55eea")
        case .ss:  Color("#4b6584")
        case .ls:  Color("#778ca3")
        }
    }
}
struct Swing: Codable, Identifiable {
    let id: Int
    let type: SwingType
    let score: Int
}

struct MatchSummary: Identifiable, Codable {
    var id: Int
    var startDate: Date
    var endDate: Date
    var duration: TimeInterval
    var totalDistance: Double
    var totalEnergyBurned: Double
    var averageHeartRate: Double
    
    var myScore: Int
    var opponentScore: Int
    var history: String
    
    var swingList: [Swing] = generateRandomSwings(count: 60)
    
    
    // 새로운 점수 변동 기록 추가
    mutating func addScore(player: Player, timestamp:Date = Date()) {
        switch(player){
        case .me:
            history.append("m")
            myScore += 1
        case .opponent:
            history.append("o")
            opponentScore += 1
        }
    }
    // 히스토리에서 맨 뒤의 기록 제거
    mutating func removeScore(player: Player) {
        switch player {
        case .me:
            if let lastIndex = history.lastIndex(of: "m") {
                history.remove(at: lastIndex)
                myScore -= 1
            }
        case .opponent:
            if let lastIndex = history.lastIndex(of: "o") {
                history.remove(at: lastIndex)
                opponentScore -= 1
            }
        }
    }
    // 히스토리에서 맨 뒤의 기록 제거하고 점수를 0으로 초기화
    mutating func resetScore(player: Player) {
        switch player {
        case .me:
            myScore = 0
            history = String(repeating:"o", count: opponentScore)
        case .opponent:
            opponentScore = 0
            history = String(repeating: "m", count: myScore)
        }
    }
}
func generateRandomSwings(count: Int) -> [Swing] {
    var randomSwings: [Swing] = []

    for i in 1...count {
        let randomType = SwingType.allCases.randomElement()!
        let randomScore = Int.random(in: 0...100)
        
        let swing = Swing(id: i, type: randomType, score: randomScore)
        randomSwings.append(swing)
    }

    return randomSwings
}

func generateRandomMatchSummaries(count: Int) -> [MatchSummary] {
    var matchSummaries = [MatchSummary]()
    let heartRateRange = 100.0...180.0

    for id in 1...count {
        let averageHeartRate = Double.random(in: heartRateRange)
        guard let workout: HKWorkout = generateRandomWorkout() else { return [] }
        var matchSummary = MatchSummary(id: id, startDate: workout.startDate, endDate: workout.endDate, duration: workout.duration, totalDistance: workout.totalDistance!.doubleValue(for: .meter()), totalEnergyBurned: workout.totalEnergyBurned!.doubleValue(for: .kilocalorie()), averageHeartRate: averageHeartRate, myScore: 0, opponentScore: 0, history:"")
        var currentTime = matchSummary.startDate
        let endTime = matchSummary.endDate
        while matchSummary.myScore < 21 && matchSummary.opponentScore < 21 && currentTime < endTime {
            let randomTimeInterval = TimeInterval(arc4random_uniform(60) + 1) // 1부터 60초 사이의 랜덤 시간 간격
            currentTime += randomTimeInterval
            let randomScore = Int(arc4random_uniform(2)) // 0 또는 1의 랜덤 점수
            let randomPlayer: Player = randomScore == 0 ? .me : .opponent
            matchSummary.addScore(player: randomPlayer, timestamp: currentTime)
        }
        matchSummaries.append(matchSummary)
    }

    return matchSummaries
}


func generateRandomWorkout() -> HKWorkout? {
    // 시작 시간을 일주일 전부터 오늘까지 랜덤으로 설정
    let endDate = Date()
    let startDate = Calendar.current.date(byAdding: .day, value: -14, to: endDate)!
    let randomStartDate = Date(timeInterval: TimeInterval.random(in: startDate.timeIntervalSinceNow...endDate.timeIntervalSinceNow), since: Date())
    
    // 운동 종류를 설정 (예시로 배드민턴 사용)
    let workoutType = HKWorkoutActivityType.badminton
    
    // 운동 시간을 10분에서 30분 사이 랜덤으로 설정
    let workoutDuration = TimeInterval.random(in: 600...1800)
    
    // 칼로리를 분당 5~7칼로리로 랜덤으로 설정
    let calorieBurnedPerMinute = Double.random(in: 5...7)
    let totalCaloriesBurned = calorieBurnedPerMinute * (workoutDuration / 60)
    
    // totalDistance를 100m에서 1km 사이 랜덤으로 설정
    let totalDistance = Double.random(in: 100...1000)
    
    // HKWorkout 생성
    let workout = HKWorkout(activityType: workoutType, start: randomStartDate, end: randomStartDate.addingTimeInterval(workoutDuration), workoutEvents: nil, totalEnergyBurned: HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: totalCaloriesBurned), totalDistance: HKQuantity(unit: HKUnit.meter(), doubleValue: totalDistance), metadata: nil)
    
    return workout
}
