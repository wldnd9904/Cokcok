//
//  ModelData.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Foundation

final class ModelData: ObservableObject {
    @Published var loggedIn:Bool
    var user:User?
    var swings:[SwingAnalyze]
    var matches:[Matches]
    
    init() {
        self.loggedIn = false
        self.user = nil
        self.swings = []
        self.matches = []
    }
}
