//
//  ModelData.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Foundation
import SwiftUI
import WatchConnectivity
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

final class ModelData: NSObject, ObservableObject {
    @Published var signState: signState = .signOut
    var uid: String = ""
    @Published var user:User?
    @Published var swings:[SwingAnalyze] = []
    @Published var matches:[MatchSummary] = []
    @Published var achievementTypes:[Int:AchievementType] = [:]
    @Published var achievements:[UserAchievement] = []
    @Published var recentAchievements:[UserAchievement] = []
    @Published var theme: ColorTheme = .system
    @Published var signingIn: Bool = false
    let isDemo = false
    let wcsession = WCSession.default
    
    override init(){
        super.init()
        self.wcsession.delegate = self
        self.wcsession.activate()
    }
    
    func signInAndGetData(token:String, onNotSignedUp: () -> Void) async -> Void {
        if isDemo {
            DispatchQueue.main.async{
                withAnimation{
                    self.signingIn = true
                    self.user = .demo
                    generateDemoAchievementTypes().forEach{
                        self.achievementTypes[$0.id] = $0
                    }
                    self.achievements = generateRandomUserAchievements(cnt: 300)
                    self.swings = generateRandomSwingData(count: 20)
                    self.matches = generateRandomMatchSummaries(count: 50)
                    self.achievements = generateRandomUserAchievements(cnt: 100)
                    self.recentAchievements = generateRandomUserAchievements(cnt: 10)
                    self.sendWatchUserData()
                    self.signingIn = false
                    self.signState = .signIn
                }
            }
        } else {
            do {
                DispatchQueue.main.async{
                    self.signingIn = true
                }
                let data = try await APIManager.shared.getMyPageInfo(token: token)
                print(data)
                switch data {
                case .codable(let userData):
                    DispatchQueue.main.async{
                        withAnimation{
                            self.user = userData.toUser()
                        }
                    }
                case .message(_):
                    onNotSignedUp()
                    return
                }
                let data2 = try await APIManager.shared.getAllAchievementTypes(token: token)
                print(data2)
                switch data2 {
                case .codable(let achievementType):
                    DispatchQueue.main.async{
                        withAnimation{
                            achievementType.forEach{
                                self.achievementTypes[$0.achieve_id] = $0.toAchievementType()
                            }
                        }
                    }
                case .message(_):
                    onNotSignedUp()
                    return
                }
                let data3 = try await APIManager.shared.getRecentAchievements(token: token)
                print(data3)
                switch data3 {
                case .codable(let achievements):
                    DispatchQueue.main.async{
                        withAnimation{
                            self.recentAchievements = achievements.map{$0.toUserAchievement(self.achievementTypes)}
                        }
                    }
                case .message(_):
                    onNotSignedUp()
                    return
                }
                let data4 = try await APIManager.shared.getAllAchievements(token: token)
                print(data4)
                switch data4 {
                case .codable(let achievements):
                    DispatchQueue.main.async{
                        withAnimation{
                            self.achievements = achievements.map{$0.toUserAchievement(self.achievementTypes)}
                        }
                    }
                case .message(_):
                    onNotSignedUp()
                    return
                }
                let data5 = try await APIManager.shared.getMatches(token: token, limit: 100, offset: 0)
                print(data5)
                switch data5 {
                case .codable(let matches):
                    DispatchQueue.main.async{
                        withAnimation{
                            self.matches = matches.map{$0.toMatchSummary()}
                            self.sendWatchUserData()
                            self.signingIn = false
                            self.signState = .signIn
                        }
                    }
                case .message(_):
                    onNotSignedUp()
                    return
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
    func sendWatchUserData(){
        if(self.wcsession.isReachable){
            if let userData = self.user{
                do{
                    self.wcsession.sendMessageData(try JSONEncoder().encode(userData), replyHandler: nil)
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ModelData: WCSessionDelegate{
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}
