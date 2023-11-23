//
//  AchievementRow.swift
//  cokcok
//
//  Created by 최지웅 on 11/23/23.
//

import SwiftUI

struct AchievementRow: View {
    let achievements:[Achievement]
    var body: some View {
        ScrollView(.horizontal, showsIndicators:false){
            HStack{
                ForEach(achievements) { item in
                    AchievementItem(item: item)
                }
            }
        }
    }
}

#Preview {
    AchievementRow(achievements: generateRandomAchievements(count: 10))
}
