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
            Summary()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("요약")
                }
            Matches()
                .tabItem {
                    Image(systemName: "waveform.path.ecg.rectangle")
                    Text("경기 분석")
                }
                .badge(10)
            SwingView()
                .tabItem {
                    Image(systemName: "figure.badminton")
                    Text("스윙 분석")
                }
        }
        .font(.headline)
    }
}

#Preview {
    ContentView()
}
