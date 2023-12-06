//
//  AchievementDetail.swift
//  cokcok
//
//  Created by 최지웅 on 11/24/23.
//

import SwiftUI

private enum MedalTab: Int, Identifiable, CaseIterable {
    var id: Int {
        self.rawValue
    }
    case bronze = 0, silver, gold, emerald, diamond
    var color:Color {
        switch(self){
        case .bronze: Color.bronze
        case .silver: Color.silver
        case .gold: Color.gold
        case .emerald: Color.emerald
        case .diamond: Color.diamond
        }
    }
    func cnt(item: AchievementType)->Int {
        switch(self){
        case .bronze: item.DMin
        case .silver: item.CMin
        case .gold: item.BMin
        case .emerald: item.AMin
        case .diamond: item.SMin
        }
    }
    func date(item: UserAchievement)->Date? {
        switch(self){
        case .bronze: item.DDate
        case .silver: item.CDate
        case .gold: item.BDate
        case .emerald: item.ADate
        case .diamond: item.SDate
        }
    }
    func prev() -> MedalTab? {
        let prevRawValue = self.rawValue - 1
        return MedalTab(rawValue: max(prevRawValue, 0))
    }
    func next() -> MedalTab? {
        let nextRawValue = self.rawValue + 1
        let maxRawValue = MedalTab.diamond.rawValue // 열거형의 최대 rawValue
        return MedalTab(rawValue: min(nextRawValue, maxRawValue))
    }
}

struct AchievementDetail: View {
    @State private var selectedTab: MedalTab = .bronze
    let item:UserAchievement
    
    var body: some View {
        ZStack{
            TabView(selection: $selectedTab,
                    content:  {
                ForEach(MedalTab.allCases){ tab in
                    VStack{
                        MedalView(medalType: item.type.icon, medalColor: tab.color)
                            .opacity(tab.cnt(item: item.type) > item.currentCnt ? 0.1 : 1.0)
                        if((item.month) != nil) {
                            Text("\(Calendar.current.component(.month, from: item.month!))월 \(item.type.name)")
                                .font(.headline)
                        } else {
                            Text("\(item.type.name)")
                                .font(.headline)
                        }
                        (Text("\(item.currentCnt)").font(.system(size: 20, weight: .bold, design: .rounded)) + Text(" /\(tab.cnt(item:item.type))\(item.type.unit)").font(.system(size: 14, weight: .semibold, design: .rounded)))
                            .padding(.bottom,2)
                        if(tab.date(item: item) != nil) {
                            Text("달성일: " + formatDateString(for:tab.date(item:item)!, toFullDate: true))
                                .font(.caption2)
                        }
                    }
                    .padding(.bottom)
                    .frame(width:180,height:270)
                    .background(.white)
                    .tag(tab)
                }
            })
            .frame(width:180,height:270)
            .cornerRadius(10)
            .tabViewStyle(.page(indexDisplayMode: .never))
            HStack{
                Button{
                    withAnimation{
                        selectedTab = selectedTab.prev()!
                    }
                } label:{
                    Image(systemName: "chevron.left")
                        .frame(width:50,height:50)
                }
                Spacer()
                Button{
                    withAnimation{
                        selectedTab = selectedTab.next()!
                    }
                } label:{
                    Image(systemName: "chevron.right")
                        .frame(width:50,height:50)
                }
            }
            .frame(width:300)
        }
        .onAppear{ 
            switch item.currentCnt {
            case item.type.DMin..<item.type.CMin:
                selectedTab = .bronze
            case item.type.CMin..<item.type.BMin:
                selectedTab = .silver
            case item.type.BMin..<item.type.AMin:
                selectedTab = .gold
            case item.type.AMin..<item.type.SMin:
                selectedTab = .emerald
            case item.type.SMin...:
                selectedTab = .diamond
            default:
                selectedTab = .bronze
            }
        }
    }
}

#Preview {
    AchievementDetail(item:generateRandomUserAchievements(cnt: 1)[0])
        .frame(width:.infinity,height:1000)
        .background(.thinMaterial)
}
