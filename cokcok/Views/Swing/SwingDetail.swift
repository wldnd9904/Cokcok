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
    @State var selectedSwing: SwingType? = nil
    
    var body: some View {
        List {
            Section(header:Text("스윙 요약").font(.title2).foregroundStyle(.primary).bold()){
                HStack() {
                    DetailItem(title: "스윙 점수", value: "\(swing.totalScore)점")
                    .accentColor(.blue)
                    DetailItem(title: "최고 손목 가속도", value: Measurement(value: swing.power,unit: UnitAcceleration.metersPerSecondSquared)
                        .formatted(.measurement(width: .abbreviated,usage: .asProvided,numberFormatStyle: .number.precision(.fractionLength(2)))))
                    .accentColor(.pink)
                }
                VideoPlayer(player:AVPlayer(url: Bundle.main.url(forResource: "sample", withExtension: "mp4")!))
                    .frame(height:420)
            }
            Section(header:Text("스윙 세부사항").font(.title2).foregroundStyle(.primary).bold()){
                DetailItem(title:"평가", value:swing.poseStrength + swing.poseWeakness+swing.wristStrength + swing.wristWeakness)
            }
        }
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
