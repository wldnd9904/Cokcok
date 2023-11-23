//
//  ModelData.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Foundation

enum ColorTheme: String, CaseIterable, Identifiable {
    var id: String {rawValue}
    case light = "밝은 모드"
    case dark = "어두운 모드"
    case system = "시스템 설정에 맞춤"
}

final class ModelData: ObservableObject {
    var user:User?
    var swings:[SwingAnalyze]
    var matches:[MatchSummary]
    var achievements:[Achievement]
    var theme: ColorTheme = .system
    init() {
        self.user = User.demo
        self.swings = generateRandomSwingData(count: 10)
        self.matches = generateRandomMatchSummaries(count: 10)
        self.achievements = generateRandomAchievements(count: 10)
    }
}
