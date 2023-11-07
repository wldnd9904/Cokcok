//
//  ContentView.swift
//  cokcok
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        TabView {
            Text("요약")
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Summary()
                }
            Text("경기 분석")
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Matches()
                }
                .badge(10)
            Text("스윙 분석")
                .tabItem {
                    Image(systemName: "figure.badminton")
                    SwingView()
                }
        }
        .font(.headline)
    }
}

#Preview {
    ContentView()
}
