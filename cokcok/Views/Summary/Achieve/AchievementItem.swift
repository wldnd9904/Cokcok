//
//  AchievementItem.swift
//  cokcok
//
//  Created by 최지웅 on 11/24/23.
//

import SwiftUI

struct AchievementItem: View {
    let item:UserAchievement
    var medalColor: Color {
        switch item.currentCnt {
        case item.type.DMin..<item.type.CMin:
            return .bronze
        case item.type.CMin..<item.type.BMin:
            return .silver
        case item.type.BMin..<item.type.AMin:
            return .gold
        case item.type.AMin..<item.type.SMin:
            return .emerald
        case item.type.SMin...:
            return .diamond
        default:
            return .bronze.opacity(0.1)
        }
    }
    var nextCnt: Int {
        switch item.currentCnt {
        case item.type.DMin..<item.type.CMin:
            return item.type.CMin
        case item.type.CMin..<item.type.BMin:
            return item.type.BMin
        case item.type.BMin..<item.type.AMin:
            return item.type.AMin
        case item.type.AMin..<item.type.SMin:
            return item.type.SMin
        case item.type.SMin...:
            return item.type.SMin
        default:
            return item.type.DMin
        }
    }
    var achieveDate: Date? {
        switch item.currentCnt {
        case item.type.DMin..<item.type.CMin:
            return item.DDate
        case item.type.CMin..<item.type.BMin:
            return item.CDate
        case item.type.BMin..<item.type.AMin:
            return item.BDate
        case item.type.AMin..<item.type.SMin:
            return item.ADate
        case item.type.SMin...:
            return item.SDate
        default:
            return nil
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                MedalView(medalType: item.type.icon, medalColor: medalColor)
                if((item.month) != nil) {
                    Text("\(Calendar.current.component(.month, from: item.month!))월 \(item.type.name)")
                        .font(.headline)
                } else {
                    Text("\(item.type.name)")
                        .font(.headline)
                }
                (Text("\(item.currentCnt)").font(.system(size: 20, weight: .bold, design: .rounded)) + Text(" \(item.type.unit)").font(.system(size: 14, weight: .semibold, design: .rounded)))
                    .padding(.bottom,2)
                if(achieveDate != nil) {
                    Text("달성일: " + formatDateString(for:achieveDate!, toFullDate: true))
                        .font(.caption2)
                }
            }
            .padding(.bottom)
            .background(.white)
            .cornerRadius(10)
        }
        .frame(width:140,height:210)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    VStack{
        AchievementItem(item:generateRandomUserAchievements(cnt: 1)[0])
        AchievementItem(item:generateRandomUserAchievements(cnt: 1)[0])
    }
        .frame(width:500,height:1000)
        .background(.thinMaterial)
}
