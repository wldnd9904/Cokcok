//
//  AchievementGrid.swift
//  cokcok
//
//  Created by 최지웅 on 11/24/23.
//


import SwiftUI

struct AchievementGrid: View {
    var cols: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    let achievements:[Achievement]
    var onTap: ((_ item:Achievement) -> Void)?
    var body: some View {
        ScrollView(showsIndicators:false){
            LazyVGrid(columns: cols){
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
                    }.scaleEffect(0.85)
                        .frame(width:120,height:180)
                }
            }
        }
    }
}

#Preview {
    AchievementGrid(achievements: generateRandomAchievements(count: 10))
        .background(Color(.systemGroupedBackground)).edgesIgnoringSafeArea(.bottom)
}
