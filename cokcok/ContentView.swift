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
            NavigationStack{
                Summary()
                    .navigationTitle("요약")
            }
            .tabItem {
                Image(systemName: "list.bullet.clipboard")
                Text("요약")
            }
            NavigationStack {
                Matches()
                    .navigationTitle("경기 분석")
            }
            .tabItem {
                Image(systemName: "waveform.path.ecg.rectangle")
                Text("경기 분석")
            }
            .badge(10)
            NavigationStack{
                SwingView()
                    .navigationTitle("스윙 분석")
            }
            .tabItem {
                Image(systemName: "figure.badminton")
                Text("스윙 분석")
            }
        }
        .background(.thinMaterial)
        .font(.headline)
    }
}

#Preview {
    ContentView()
}
