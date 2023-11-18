//
//  Swing.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import SwiftUI

struct SwingView: View {
    @State var path: [String] = []
    @State var isShownFullScreenCover = false
    let swingList: [SwingAnalyze] = generateRandomSwingData(count: 10)
    var body: some View {
        ScrollView(showsIndicators:false){            HStack {
            SectionTitle(title: "최근 나의 스윙")
            NavigationLink(destination: {
                Text("스윙리스트")
            }) {
                Text("더보기")
            }
        }
            SwingTrendChart(swings:swingList)
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            

            VStack{
                ForEach(swingList.reversed()){ swing in
                    SwingItem(swing: swing)
                }
            }
        }
        .padding()
        .background(Color(.systemGroupedBackground)).edgesIgnoringSafeArea(.bottom)
        .toolbar{
            Button {
            self.isShownFullScreenCover.toggle()
            } label: {
                Text("새 스윙 측정하기")
            }
        }
        .fullScreenCover(isPresented: $isShownFullScreenCover) {
            SwingRecordView(dismiss:{isShownFullScreenCover = false})
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

#Preview {
    TabView{
        NavigationStack{
            SwingView()
                .navigationTitle("스윙 분석")
        }.tabItem { Text("스윙 분석") }
    }
}
