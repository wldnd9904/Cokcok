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
enum signState {
    case signIn
    case signOut
}

final class ModelData: ObservableObject {
    @Published var signState: signState = .signOut
    var uid: String = ""
    @Published var user:User?
    @Published var swings:[SwingAnalyze] = []
    @Published var matches:[MatchSummary] = []
    @Published var achievementTypes:[Int:AchievementType] = [:]
    @Published var achievements:[UserAchievement] = []
    @Published var theme: ColorTheme = .system
}
