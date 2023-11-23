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
    @State var path: [String] = []
    @Binding var showMyPage:Bool
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
                }.padding(.bottom)
            }
            
            SectionTitle(title: "경기 분석")
            RecentMatch()
            
            SectionTitle(title: "업적")
            AchievementRow(achievements: modelData.achievements)
        }
        .padding()
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
            .environmentObject(ModelData())
            .navigationTitle("요약")
    }
}
