//
//  AchievementsView.swift
//  cokcok
//
//  Created by 최지웅 on 11/24/23.
//

import SwiftUI

struct AchievementsView: View {
    var cols: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var achievements: [Achievement]
    @State var selectedAchievement:Achievement? = nil
    var achievementsWithoutMonth: [Achievement] { achievements.filter { $0.month == nil }
    }
    // 월별로 그룹화
    var groupedByMonth: Dictionary<Date, [Achievement]> { Dictionary(grouping: achievements.filter {        $0.month != nil
    }, by: { achievement in
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: achievement.month!)
        return calendar.date(from: components)!
    })
    }
    var body: some View {
        ScrollView(showsIndicators: false){
            SectionTitle(title: "일반 업적")
            AchievementGrid(achievements: achievementsWithoutMonth){item in
                selectedAchievement = item
            }
            ForEach(groupedByMonth.keys.sorted().reversed(), id:\.timeIntervalSince1970){ key in
                VStack{
                    SectionTitle(title: "\(Calendar.current.component(.year, from: key)%100)년 \(Calendar.current.component(.month, from: key))월 업적")
                        .padding(.top)
                    AchievementGrid(achievements: groupedByMonth[key]!){item in
                        selectedAchievement = item
                    }
                }
            }
        }
        .padding()
        
        //오버레이
        .overlay{
            if(selectedAchievement != nil){
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedAchievement = nil
                    }
                AchievementDetail(item: selectedAchievement!)
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
private struct SectionTitle: View {
    let title: String
    var body: some View {
        HStack{
            Text(title)
                .bold().font(.title2)
            Spacer()
        }
    }
}
#Preview {
    NavigationStack{
        AchievementsView(achievements:generateRandomAchievements(count: 50))
            .environmentObject(ModelData())
            .navigationTitle("도전 과제")
    }
}
