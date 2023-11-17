//
//  ContentView.swift
//  cokcok
//
//  Created by 최지웅 on 11/4/23.
//

import SwiftUI


struct ContentView : View {
    private enum Tab:Hashable {
        case swing, summary, matches
    }
    @State private var selectedTab: Tab = .summary
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack{
                SwingView()
                    .navigationTitle("스윙 분석")
            }
            .tabItem {
                Image(systemName: "figure.badminton")
                Text("스윙 분석")
            }
            .tag(Tab.swing)
            
            NavigationStack{
                Summary()
                    .navigationTitle("요약")
            }
            .tabItem {
                Image(systemName: "list.bullet.clipboard")
                Text("요약")
            }
            .tag(Tab.summary)
            
            NavigationStack {
                Matches()
                    .navigationTitle("경기 분석")
            }
            .tabItem {
                Image(systemName: "waveform.path.ecg.rectangle")
                Text("경기 분석")
            }
            .badge(10)
            .tag(Tab.matches)
            
        }
        .background(.thinMaterial)
        .font(.headline)
    }
}

#Preview {
    ContentView()
}
