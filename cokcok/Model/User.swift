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
    case beginner = "초심"
    case d = "D조"
    case c = "C조"
    case b = "B조"
    case a = "A조"
    case jagang = "자강"
}


public struct User:Identifiable {
    public var id: String
    var email: String
    var authType: AuthType
    var hand: Hand
    var sex: Sex
    var grade: Grade 
    var years: Int
    static let demo = User(id: "gdgdd", email:"heung@never.com", authType: .kakao, hand: .left, sex: .male, grade: .c, years: 4)
}
