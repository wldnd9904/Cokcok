//
//  PathManager.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/28/23.
//

import Foundation
enum MenuType: UInt, Identifiable, CaseIterable, Hashable {
    case swingRecord, matchRecord, savedData
    
    public var id:UInt {
        rawValue
    }
    var name: String {
        switch self {
        case .swingRecord:
            return "스윙 분석"
        case .matchRecord:
            return "경기 기록"
        case .savedData:
            return "Debug: 저장된 경기 확인"
        }
    }
}

class PathManager: ObservableObject{
    static let shared = PathManager() // Shared 객체 생성
    @Published var path: [MenuType] = []
}
