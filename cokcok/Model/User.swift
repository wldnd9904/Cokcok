//
//  User.swift
//	  cokcok
//
//  Created by 최지웅 on 11/14/23.
//

import Foundation
enum Hand: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    case left = "왼손"
    case right = "오른손"
    func toAPI() -> String {
        switch(self){
        case .left: "L"
        case .right: "R"
        }
    }
}
enum Sex: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    case male = "남성"
    case female = "여성"
    case etc = "기타"
    func toAPI() -> String {
        switch(self){
        case .male: "M"
        case .female: "F"
        case .etc: "O"
        }
    }
}
enum Grade: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    case beginner = "초심"
    case d = "D조"
    case c = "C조"
    case b = "B조"
    case a = "A조"
    case jagang = "자강"
    func toAPI() -> String {
        switch(self){
        case .beginner:
            "E"
        case .d:
            "D"
        case .c:
            "C"
        case .b:
            "B"
        case .a:
            "A"
        case .jagang:
            "S"
        }
    }
}


public struct User:Identifiable, Codable {
    public var id: String
    var email: String
    var authType: AuthType
    var hand: Hand
    var sex: Sex
    var grade: Grade 
    var years: Int
    static let demo = User(id: "gdgdd", email:"heung@never.com", authType: .kakao, hand: .left, sex: .male, grade: .c, years: 4)
}
