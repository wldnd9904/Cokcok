//
//  APIAdapater.swift
//  cokcok
//
//  Created by 최지웅 on 12/5/23.
//
//  ERD의 스키마 그대로 가져옴

import Foundation

struct MatchAPI: Codable {
    let match_id: Int
    let start_date: Date
    let end_date: Date
    let duration: Int
    let total_distance: Double
    let total_energy_burned: Double
    let average_heart_rate: Double
    let my_score: Int
    let opponent_score: Int
    let score_history: String
    let back_drive: Int
    let back_hairpin: Int
    let back_high: Int
    let back_under: Int
    let fore_drive: Int
    let fore_drop: Int
    let fore_hairpin: Int
    let fore_high: Int
    let fore_smash: Int
    let fore_under: Int
    let long_service: Int
    let short_service: Int
    let watch_url: String
    let player_token: String
    
    /*func toMatchSummary()-> MatchSummary {
        MatchSummary(id: match_id, startDate: start_date, endDate: end_date, duration: TimeInterval(integerLiteral: Int64(duration)), totalDistance: total_distance, totalEnergyBurned: total_energy_burned, averageHeartRate: average_heart_rate, myScore: my_score, opponentScore: opponent_score, history: score_history, backDrive: back_drive, backHairpin: back_hairpin, backHigh: back_high, backUnder: back_under,foreDrive: fore_drive,foreDrop: fore_drop,foreHairpin: fore_hairpin,foreHigh: fore_high, foreSmash: fore_smash,foreUnder: fore_under,longService: long_service,shortService: short_service)
    }*/
}

struct PlayerAPI: Codable {
    let player_token: String
    let sex: String
    let years_playing: Int
    let grade: String
    let handedness: String
    let email: String
    let sns: String
    
    func toUser() -> User {
        User(id: player_token, email: email, authType: {
            switch(sns){
            case "kakao": .kakao
            case "google": .google
            case "apple": .apple
            default: .apple
            }
        }(), hand: {switch(handedness) {
        case "L": .left
        case "R": .right
        default: .right
        }}(), sex: {switch(sex){
        case "M": .male
        case "F": .female
        case "O": .etc
        default: .etc
        }}(), grade: {switch(grade){
        case "E": .beginner
        case "D": .d
        case "C": .c
        case "B": .b
        case "A": .a
        case "S": .jagang
        default: .beginner
        }}(), years: years_playing)
    }
}

struct AchievementAPI: Codable {
    let achieve_id: Int
    let achieve_nm: String
    let d_min: Int
    let c_min: Int
    let b_min: Int
    let a_min: Int
    let s_min: Int
    let is_month_update: String
    let icon: String
}

struct PlayerAchievementAPI: Codable {
    let relation_id: Int
    let player_token: String
    let achieve_id: Int
    let cumulative_val: Int
    let achieve_year_month: Date?
    let d_achieve_date: Date?
    let c_achieve_date: Date?
    let b_achieve_date: Date?
    let a_achieve_date: Date?
    let s_achieve_date: Date?
    let last_achieve_date: Date?
}

struct MotionAPI: Codable{
    let motion_id: Int
    let video_url: String
    let watch_url: String
    let pose_strength: String
    let wrist_strength: String
    let pose_weakness: String
    let wrist_weakness: String
    let player_token: String
    let record_date: Date
    let swing_score: Int
}

