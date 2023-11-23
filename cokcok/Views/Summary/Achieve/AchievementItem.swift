//
//  AchievementItem.swift
//  cokcok
//
//  Created by 최지웅 on 11/24/23.
//

import SwiftUI

struct AchievementItem: View {
    let item:Achievement
    var medalColor: Color {
        switch item.currentCnt {
        case item.ECnt..<item.DCnt:
            return .bronze
        case item.DCnt..<item.CCnt:
            return .silver
        case item.CCnt..<item.BCnt:
            return .gold
        case item.BCnt..<item.ACnt:
            return .emerald
        case item.ACnt...:
            return .diamond
        default:
            return .bronze.opacity(0.1)
        }
    }
    var nextCnt: Int {
        switch item.currentCnt {
        case item.ECnt..<item.DCnt:
            return item.DCnt
        case item.DCnt..<item.CCnt:
            return item.CCnt
        case item.CCnt..<item.BCnt:
            return item.BCnt
        case item.BCnt..<item.ACnt:
            return item.ACnt
        case item.ACnt...:
            return item.ACnt
        default:
            return item.ECnt
        }
    }
    var achieveDate: Date? {
        switch item.currentCnt {
        case item.ECnt..<item.DCnt:
            return item.EDate
        case item.DCnt..<item.CCnt:
            return item.DDate
        case item.CCnt..<item.BCnt:
            return item.CDate
        case item.BCnt..<item.ACnt:
            return item.BDate
        case item.ACnt...:
            return item.ADate
        default:
            return nil
        }
    }
    
    var body: some View {
        ZStack{
            VStack{
                MedalView(medalType: item.symbol, medalColor: medalColor)
                Text("\(item.name)")
                    .font(.headline)
                Text("\(item.currentCnt)/\(nextCnt) \(item.unit)")
                    .font(.subheadline)
                if(achieveDate != nil) {
                    Text("달성일: " + formatDateString(for:achieveDate!, toFullDate: true))
                        .font(.caption2)
                }
            }
            .padding(.bottom)
            .background(.white)
            .cornerRadius(10)
            if(item.isNew){
                VStack{
                    HStack{
                        Spacer()
                        Circle()
                            .fill(Color.pink)
                            .frame(width: 7, height: 7)
                            .padding(7)
                    }
                    Spacer()
                }
            }
        }
        .frame(width:140,height:210)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    AchievementItem(item:generateRandomAchievements(count: 1)[0])
        .frame(width:500,height:1000)
        .background(.thinMaterial)
}
