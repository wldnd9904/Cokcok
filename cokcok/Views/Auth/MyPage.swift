//
//  MyPage.swift
//  cokcok
//
//  Created by 최지웅 on 11/22/23.
//

import SwiftUI

struct MyPage: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Binding var isPresented: Bool
    var body: some View {
        Button("로그아웃") {
            isPresented = false
            authManager.signOut()
        }
    }
}

#Preview {
    MyPage(isPresented: .constant(true))
        .environmentObject(AuthenticationManager())
}
