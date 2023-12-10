//
//  SwingDetail.swift
//  cokcok
//
//  Created by 최지웅 on 12/8/23.
//

import SwiftUI
import AVKit

struct SwingDetail: View {
    let swing: SwingAnalyze
    @State var selectedSwingPhase:Int = 1
    
    var body: some View {
        List {
            Section(header:Text("스윙 요약").font(.title2).foregroundStyle(.primary).bold()){
                VStack(alignment:.leading,spacing:3){
                    Text("기록일시")
                        .bold()
                    Text(formatFullDateHourMinutes(swing.recordDate))
                        .foregroundStyle(Color.indigo)
                }
                HStack {
                    DetailItem(title: "스윙 점수", value: "\(swing.swingScore)점")
                    .accentColor(.blue)
                    DetailItem(title: "최고 손목 가속도", value: Measurement(value: swing.wristMaxAcceleration,unit: UnitAcceleration.metersPerSecondSquared)
                        .formatted(.measurement(width: .abbreviated,usage: .asProvided,numberFormatStyle: .number.precision(.fractionLength(2)))))
                    .accentColor(.pink)
                }
            }
            Section(header:Text("스윙 세부사항").font(.title2).foregroundStyle(.primary).bold()){
                VStack(alignment:.leading){
                    Text("스윙 구간별 점수")
                        .bold()
                    SwingScoreChart(scoreList:swing.swingScoreList, selectedPhase: $selectedSwingPhase)
                        .frame(height:200)
                }
                HStack{
                    Button{
                        withAnimation{
                            if(selectedSwingPhase>1){
                                selectedSwingPhase -= 1
                            }
                        }
                    } label:{
                        Image(systemName: "chevron.left")
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedSwingPhase == 1)
                    .frame(width:0)
                    TabView(selection: $selectedSwingPhase){
                        VStack(alignment:.leading, spacing:5){
                            HStack{
                                DetailItem(title:"구간", value:"임팩트 이전")
                                DetailItem(title:"점수", value:String(format:"%.1f",swing.resPrepare)+"점")
                            }
                            .padding(.bottom)
                            if(swing.wristPrepareStrength.count>0){
                                VStack(alignment:.leading){
                                    Text("장점")
                                        .bold()
                                    Text(swing.wristPrepareStrength)
                                        .foregroundStyle(.green)
                                }
                            }
                            if(swing.wristPrepareWeakness.count>0){
                                VStack(alignment:.leading){
                                    Text("단점")
                                        .bold()
                                    Text(swing.wristPrepareWeakness)
                                        .foregroundStyle(.pink)
                                }
                            }
                            Spacer()
                        }
                        .tag(1)
                        VStack(alignment:.leading, spacing:5){
                            HStack{
                                DetailItem(title:"구간", value:"임팩트")
                                DetailItem(title:"점수", value:String(format:"%.1f",swing.resImpact)+"점")
                            }
                            .padding(.bottom)
                            if(swing.wristImpactStrength.count>0){
                                VStack(alignment:.leading){
                                    Text("장점")
                                        .bold()
                                    Text(swing.wristImpactStrength)
                                        .foregroundStyle(.green)
                                }
                            }
                            if(swing.wristImpactWeakness.count>0){
                                VStack(alignment:.leading){
                                    Text("단점")
                                        .bold()
                                    Text(swing.wristImpactWeakness)
                                        .foregroundStyle(.pink)
                                }
                            }
                            Spacer()
                        }
                        .tag(2)
                        VStack(alignment:.leading, spacing:5){
                            HStack{
                                    DetailItem(title:"구간", value:"임팩트 이후")
                                    DetailItem(title:"점수", value:String(format:"%.1f",swing.resFollow)+"점")
                            }
                            .padding(.bottom)
                            if(swing.wristFollowStrength.count>0){
                                VStack(alignment:.leading){
                                    Text("장점")
                                        .bold()
                                    Text(swing.wristFollowStrength)
                                        .foregroundStyle(.green)
                                }
                            }
                            if(swing.wristFollowWeakness.count>0){
                                VStack(alignment:.leading){
                                    Text("단점")
                                        .bold()
                                    Text(swing.wristFollowWeakness)
                                        .foregroundStyle(.pink)
                                }
                            }
                            Spacer()
                        }
                        .tag(3)
                    }
                    .frame(height:300)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    Button{
                        withAnimation{
                            if(selectedSwingPhase<3){
                                selectedSwingPhase += 1
                            }
                        }
                    } label:{
                        Image(systemName: "chevron.right")
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedSwingPhase == 3)
                    .frame(width:0)
                }
                if(swing.poseStrength.count>0){
                    VStack(alignment:.leading){
                        Text("자세 장점")
                            .bold()
                        Text(swing.poseStrength)
                            .foregroundStyle(.green)
                    }
                }
                if(swing.poseWeakness.count>0){
                    VStack(alignment:.leading){
                        Text("자세 단점")
                            .bold()
                        Text(swing.poseWeakness)
                            .foregroundStyle(.pink)
                    }
                }
            }
            Section(header:Text("스윙 영상").font(.title2).foregroundStyle(.primary).bold()){
                VideoPlayer(player:AVPlayer(url:swing.videoUrl))
                    .frame(height:420)
            }
            
            Button("스윙 기록 삭제하기"){
            }
            .tint(.red)
        }
        .multilineTextAlignment(.leading)
        .scrollIndicators(.hidden)
    }
    
    private struct StrokeItem: View {
        @Binding var selectedSwing: SwingType?
        let type: SwingType
        let swingList: [Swing]
        var filteredSwingList: [Swing] {
            swingList.filter{$0.type == type}
        }
        var avgScore: Double {
            if filteredSwingList.count == 0 {0}            else {
                Double(filteredSwingList.reduce(0){$0 + $1.score
                })/Double(filteredSwingList.count)
            }
        }
        
        var body: some View {
            VStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle()
                            .stroke(type.color, lineWidth: 3)
                            .frame(width: 60, height: 60)
                    )
                    .overlay{
                        if selectedSwing == type {
                            Text(String(format:"%.1f", avgScore))
                                .font(.title2)+Text("점").font(.subheadline)
                        } else {
                            Text("\(filteredSwingList.count)")
                                .font(.title)+Text("회").font(.subheadline)
                        }
                    }
                    .foregroundColor(type.color)
                Text(type.rawValue)
                    .font(.caption)
            }
            .onTapGesture {
                if(selectedSwing == type){
                    withAnimation{
                        selectedSwing = nil
                    }
                }else {
                    withAnimation{
                        selectedSwing = type
                    }
                }
            }
        }
    }
}

private struct DetailItem: View {
    var title: String
    var value: String

    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .bold()
                Text(value)
                    .font(.system(.title2, design: .rounded)
                        .lowercaseSmallCaps()
                    )
                    .foregroundColor(.accentColor)
            }
            Spacer()
        }
    }
}

#Preview {
    SwingDetail(swing:generateRandomSwingData(count: 1)[0])
}
