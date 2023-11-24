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
    func cnt(item: Achievement)->Int {
        switch(self){
        case .bronze: item.ECnt
        case .silver: item.DCnt
        case .gold: item.CCnt
        case .emerald: item.BCnt
        case .diamond: item.ACnt
        }
    }
    func date(item: Achievement)->Date? {
        switch(self){
        case .bronze: item.EDate
        case .silver: item.DDate
        case .gold: item.CDate
        case .emerald: item.BDate
        case .diamond: item.ADate
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
    let item:Achievement
    
    var body: some View {
        ZStack{
            TabView(selection: $selectedTab,
                    content:  {
                ForEach(MedalTab.allCases){ tab in
                    VStack{
                        MedalView(medalType: item.symbol, medalColor: tab.color)
                            .opacity(tab.cnt(item: item) > item.currentCnt ? 0.1 : 1.0)
                        if((item.month) != nil) {
                            Text("\(Calendar.current.component(.month, from: item.month!))월 \(item.name)")
                                .font(.headline)
                        } else {
                            Text("\(item.name)")
                                .font(.headline)
                        }
                        (Text("\(item.currentCnt)").font(.system(size: 20, weight: .bold, design: .rounded)) + Text(" /\(tab.cnt(item:item))\(item.unit)").font(.system(size: 14, weight: .semibold, design: .rounded)))
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
            case item.ECnt..<item.DCnt:
                selectedTab = .bronze
            case item.DCnt..<item.CCnt:
                selectedTab = .silver
            case item.CCnt..<item.BCnt:
                selectedTab = .gold
            case item.BCnt..<item.ACnt:
                selectedTab = .emerald
            case item.ACnt...:
                selectedTab = .diamond
            default:
                selectedTab = .bronze
            }
        }
    }
}

#Preview {
    AchievementDetail(item:generateRandomAchievements(count: 1)[0])
        .frame(width:.infinity,height:1000)
        .background(.thinMaterial)
}
