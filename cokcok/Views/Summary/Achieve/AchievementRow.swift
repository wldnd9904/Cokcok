//
//  AchievementRow.swift
//  cokcok
//
//  Created by 최지웅 on 11/23/23.
//

import SwiftUI

struct AchievementRow: View {
    var rows: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    let achievements:[UserAchievement]
    var onTap: ((_ item:UserAchievement) -> Void)?
    var body: some View {
        if achievements.isEmpty {
            Text("달성한 업적이 없습니다. 경기를 기록해 보세요!")
                .padding(.vertical,20)
        } else {
            ScrollView(.horizontal, showsIndicators:false){
                LazyHGrid(rows: rows){
                    ForEach(achievements) { item in
                        ZStack{
                            AchievementItem(item: item)
                            Color.black
                                .opacity(0.0000001)
                                .onTapGesture {
                                    if(onTap != nil ) {
                                        onTap!(item)
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AchievementRow(achievements: generateRandomUserAchievements(cnt: 10))
}
