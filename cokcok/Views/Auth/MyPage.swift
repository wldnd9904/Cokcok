//
//  MyPage.swift
//  cokcok
//
//  Created by 최지웅 on 11/22/23.
//

import SwiftUI

struct MyPage: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        Button("로그아웃") {
            authManager.signOut()
        }
    }
}

#Preview {
    MyPage()
        .environmentObject(AuthenticationManager())
}
