//
//  Summary.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import SwiftUI
struct Row: Identifiable, Hashable {
    var id = UUID()
    var label: String
    var image: String
    var value: String
    var unit: String
    var color: Color
}
struct Summary: View {
    @EnvironmentObject var modelData: ModelData
    @State var showMyPage:Bool = false
    @State var selectedAchievement:UserAchievement?
    @State var selectedSummaryType: SummaryType = .matchCount
    let month = Calendar.current.component(.month, from: Date())
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack{
                SectionTitle(title: "\(month)월 경기 요약")
                SummaryRow(matches:modelData.matches.filter{Calendar.current.component(.month, from: $0.startDate) == month}, selectedSummaryType: $selectedSummaryType)
                SummaryCharts(matches:  modelData.matches.filter{Calendar.current.component(.month, from: $0.startDate) == month}, selectedSummaryType: $selectedSummaryType)
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 440,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .background(.white)
                    .cornerRadius(10)
                HStack{
                    SectionTitle(title: "최근 달성 업적")
                    Spacer()
                    NavigationLink(destination:AchievementsView(achievements:modelData.achievements)
                        .navigationTitle("전체 업적")
                    ){Text("더보기")}
                }
                .padding(.top)
                AchievementRow(achievements: modelData.recentAchievements){item in
                    selectedAchievement = item
                }
                .cornerRadius(10)
            }
            .padding()
            .padding(.bottom,50)
        }
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
        .toolbar{
            Button {
                showMyPage.toggle()
            } label: {
                Label("사용자 프로필", systemImage: "person.crop.circle")
            }
        }
        .sheet(isPresented: $showMyPage, content: {
            MyPage(isPresented: $showMyPage)
        })
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
        Summary()
            .navigationTitle("요약")
    }
    .environmentObject(ModelData())
}
