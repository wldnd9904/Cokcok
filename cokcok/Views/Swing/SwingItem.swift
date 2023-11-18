//
//  SwingItem.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import SwiftUI

struct SwingItem: View {
    let swing:SwingAnalyze
    
    func scoreDescription(for score: Int) -> String {
        switch score {
        case 0..<10:
            return "형편없음"
        case 10..<50:
            let lackingSkills = ["그립", "백스윙", "속도", "자세"].shuffled().prefix(2)
            return "\(lackingSkills[0]), \(lackingSkills[1]) 부족"
        case 50..<80:
            let lackingSkill = ["그립", "백스윙", "속도", "자세"].randomElement() ?? "잘 모름"
            return "\(lackingSkill) 부족"
        case 80..<90:
            return "전체적으로 양호"
        case 90...100:
            return "최고!"
        default:
            return "잘 모름"
        }
    }
    
    var body: some View {
        ZStack{
            HStack(alignment:.center) {
                Text("\(swing.score)")
                    .bold()
                    .foregroundStyle(.blue)
                    .font(.title)
                Text("점")
                    .bold()
                    .foregroundStyle(.gray)
                Spacer()
                Text(formatDateString(for: swing.date))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Text(scoreDescription(for: swing.score))
                .font(.headline)
        }
        .frame(maxWidth: .infinity) // 최대 너비 제한
        .padding(15)
        .background(.white)
        .cornerRadius(10)
    }
}

#Preview {
    SwingItem(swing:generateRandomSwingData(count: 1)[0])
}
