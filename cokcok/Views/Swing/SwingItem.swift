//
//  SwingItem.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import SwiftUI

struct SwingItem: View {
    let swing:SwingAnalyze
    
    var body: some View {
        ZStack{
            HStack(alignment:.center) {
                Text("\(swing.swingScore)")
                    .bold()
                    .foregroundStyle(.blue)
                    .font(.title)
                Text("점")
                    .bold()
                    .foregroundStyle(.gray)
                Spacer()
                Text(formatDateString(for: swing.recordDate))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
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
