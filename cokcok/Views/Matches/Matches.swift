//
//  Matches.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import SwiftUI

struct Matches: View {
    @EnvironmentObject var model: ModelData
    @State var matchGroups: [Date: [MatchSummary]] = [:]
    @State var showAlert: Bool = false 
    @State var isDeleted: Bool = false
    let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    var body: some View {
        ScrollView(showsIndicators: false){
            if(model.matches.isEmpty){
                HStack(alignment: .center){
                    Spacer()
                    VStack{
                        Spacer()
                        Text("경기 기록이 없습니다.")
                        Text("애플워치 앱에서 경기를 기록할 수 있습니다.")
                        Spacer()
                    }
                    Spacer()
                }
            } else {
                LazyVStack(pinnedViews:[.sectionHeaders]){
                    ForEach(Array(matchGroups.keys.sorted{$0>$1}), id:\.self){ key in
                        Section(header:SectionTitle(title: key == sevenDaysAgo ? "최근 7일" : formatDateToYearMonth(key))){
                            ForEach(matchGroups[key] ?? [], id: \.id) { match in
                                NavigationLink(destination: MatchDetail(match:match){
                                    model.matches.removeAll{$0.id == match.id}
                                    Task{
                                        do{
                                            let res = try await APIManager.shared.deleteMatch(token: model.user?.id ?? "", matchID: match.id)
                                            print(res)
                                        } catch { print(error.localizedDescription)}
                                    }
                                }
                                    .navigationTitle(formatDateWithDay(match.startDate))){
                                        MatchItem(match: match)
                                            .padding(.horizontal,5)
                                    }
                            }
                        }
                    }
                }
                .padding()
                .padding(.bottom,50)
            }
        }
        .onAppear{
            setMatchGroups()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("전체 삭제") {
                        showAlert.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .alert(isPresented: $showAlert) {
            if !isDeleted {
                Alert(
                    title: Text("삭제 확인"),
                    message: Text("삭제하시겠습니까?"),
                    primaryButton: .destructive(Text("삭제")) {
                        // 확인 버튼이 눌렸을 때
                        Task {
                            do{
                               let res = try await APIManager.shared.deleteAllMatches(token: model.user?.id ?? "")
                                print(res)
                            } catch { print(error.localizedDescription)}
                            DispatchQueue.main.async{
                                showAlert.toggle()
                                isDeleted = true
                                model.matches = []
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            } else {
                Alert(
                    title: Text("삭제 완료"),
                    message: Text("삭제되었습니다."),
                    dismissButton: .default(Text("확인"))
                )
            }
        }
    }
    
    func setMatchGroups() {
        matchGroups = Dictionary(grouping: model.matches.sorted{$0.startDate > $1.startDate}
        ) { matchSummary in
            if matchSummary.startDate >= sevenDaysAgo {
                // 최근 7일 이내의 경우
                return sevenDaysAgo
            } else {
                // 그 외의 경우, 월별로 그룹화
                let components = Calendar.current.dateComponents([.year, .month], from: matchSummary.startDate)
                return Calendar.current.date(from: components)!
            }
        }
    }
}


private struct SectionTitle: View {
    let title: String
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGroupedBackground).opacity(1.0),
                    Color(.systemGroupedBackground).opacity(0.0)
                ]),
                startPoint: .center,
                endPoint: .bottom
            )
            HStack{
                Text(title)
                    .bold().font(.title2)
                    .padding(.vertical)
                Spacer()
            }
        }
    }
}
    
#Preview {
    NavigationStack{
        Matches()
            .environmentObject(ModelData())
    }
}
