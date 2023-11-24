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
    @Binding var showMyPage:Bool
    @State var selectedAchievement:Achievement?
    var columns = [
        GridItem(.adaptive(minimum: 180, maximum: 300), spacing: 8)
    ]
    
    var array: [Row] = [
        Row(label: "경기 수", image: "play.circle", value: "31", unit: "회", color:.orange),
        Row(label: "승률", image: "figure.dance", value: "71.2", unit: "%",color:.pink),
        Row(label: "이동 거리", image: "figure.run", value: "2.4", unit: "km",color:.blue),
        Row(label: "경기 시간", image: "stopwatch", value: "165:14", unit: "시간", color:.green),
        Row(label: "스윙 수", image: "figure.badminton", value: "3105", unit: "회", color:.orange),
    ]
    var body: some View {
        ScrollView{
            SectionTitle(title: "11월 경기 요약")
            ScrollView(.horizontal, showsIndicators: false){
                LazyHGrid(rows: columns, spacing: 8) {
                    ForEach(array) { row in
                        GroupBox(label: Label(row.label, systemImage: row.image)) {
                            SummaryValueView(value: row.value, unit: row.unit)
                        }.groupBoxStyle(SummaryGroupBoxStyle(color: row.color, destination: EmptyView()))
                    }
                }
            }
            .cornerRadius(10)
            
            SectionTitle(title: "경기 분석")
                .padding(.top)
            RecentMatch()
            
            HStack{
                SectionTitle(title: "최근 달성 업적")
                Spacer()
                NavigationLink(destination:AchievementsView(achievements:modelData.achievements)
                    .navigationTitle("전체 업적")
                ){Text("더보기")}
            }
            .padding(.top)
            AchievementRow(achievements: modelData.achievements){item in
                selectedAchievement = item
            }
            .cornerRadius(10)
        }
        .padding()
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
        .background(Color(.systemGroupedBackground)).edgesIgnoringSafeArea(.bottom)
        .toolbar{
            Button {
                showMyPage.toggle()
            } label: {
                Label("사용자 프로필", systemImage: "person.crop.circle")
            }
        }
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

private struct SummaryValueView: View {
    var value: String
    var unit: String
    
    @ScaledMetric var size: CGFloat = 1
    
    @ViewBuilder var body: some View {
        HStack {
            Text(value).font(.system(size: 24 * size, weight: .bold, design: .rounded)) + Text(" \(unit)").font(.system(size: 14 * size, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
            Spacer()
        }
    }
}



#Preview {
    NavigationStack{
        Summary(showMyPage: .constant(false))
            .navigationTitle("요약")
    }
    .environmentObject(ModelData())
}
