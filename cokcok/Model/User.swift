//
//  User.swift
//	  cokcok
//
//  Created by 최지웅 on 11/14/23.
//

import Foundation
enum Hand: String, CaseIterable, Identifiable {
    var id: String {rawValue}
    case left = "왼손"
    case right = "오른손"
}
enum Sex: String, CaseIterable, Identifiable {
    var id: String {rawValue}
    case male = "남성"
    case female = "여성"
    case etc = "기타"
}
enum Grade: String, CaseIterable, Identifiable {
    var id: String {rawValue}
    case jagang = "자강조"
    case a = "A조"
    case b = "B조"
    case c = "C조"
    case d = "D조"
    case beginner = "초심"
}


public struct User:Identifiable {
    public var id: UUID
    var name: String
    var hand: Hand
    var sex: Sex
    var grade: Grade 
    var years_played: Int
    static let demo = User(id: UUID(), name: "손흥민", hand: .left, sex: .male, grade: .c, years_played: 4)
}
