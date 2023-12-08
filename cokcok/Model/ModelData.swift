//
//  ModelData.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Foundation
import SwiftUI
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
    @Published var matches:[MatchSummary] = generateRandomMatchSummaries(count: 30)
    @Published var achievementTypes:[Int:AchievementType] = [:]
    @Published var achievements:[UserAchievement] = []
    @Published var theme: ColorTheme = .system
    let isDemo = true
    
    func signInAndGetData(token:String, onNotSignedUp: () -> Void) async -> Void {
        if isDemo {
            DispatchQueue.main.async{
                withAnimation{
                    self.user = .demo
                    self.signState = .signIn
                    generateDemoAchievementTypes().forEach{
                        self.achievementTypes[$0.id] = $0
                    }
                    self.achievements = generateRandomUserAchievements(cnt: 300)
                    self.swings = generateRandomSwingData(count: 20)
                    self.matches = generateRandomMatchSummaries(count: 30)
                }
            }
        } else {
            do {
                let data = try await APIManager.shared.getMyPageInfo(token: token)
                switch data {
                case .codable(let userData):
                    DispatchQueue.main.async{
                        withAnimation{
                            self.user = userData.toUser()
                            self.signState = .signIn
                        }
                    }
                case .message(_):
                    onNotSignedUp()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func signUpAndSetEmptyData(user:User) async -> Void {
        if !isDemo {
            do {
                let _ = try await APIManager.shared.signUp(token: user.id, sex: user.sex, yearsPlaying: user.years, grade: user.grade, handedness: user.hand, email: user.email, authType: user.authType)
            } catch {
                print(error.localizedDescription)
            }
        }
        DispatchQueue.main.async{
            withAnimation{
                self.user = user
                self.signState = .signIn
                self.matches = []
                self.achievements = []
                self.swings = []
            }
        }
    }
}
