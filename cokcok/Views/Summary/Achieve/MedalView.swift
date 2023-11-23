//
//  MedalView.swift
//  cokcok
//
//  Created by 최지웅 on 11/15/23.
//

import SwiftUI

struct MedalView: View {
    
    var medalType: String
    var medalColor: Color
    @State var angle: Double = 0

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(medalColor)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Circle()
                            .stroke(medalColor, lineWidth: 5)
                            .blur(radius: 4)
                            .brightness(1.5)
                            .mask(Circle().fill(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .top, endPoint: .bottom)))
                            .frame(width: 100, height: 100)
                    )
                Image(systemName: medalType) // 여기에 이미지를 넣어주세요.
                    .resizable()
                    .foregroundColor(.white)
                    .opacity(0.3)
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipped()
                
                Circle()
                    .fill(RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.5), Color.clear]), center: .topLeading, startRadius: 0, endRadius: 100))
                    .frame(width: 100, height: 100)
            }
            .rotation3DEffect(.degrees(angle), axis: (x: 0, y: 1, z: 0),perspective: 0.5)
            .shadow(color:Color(.gray).opacity(0.4), radius: 3,x:3,y:3)
            .onTapGesture {
                angle = 0
                withAnimation{
                    angle = 360
                }
            }
            .padding()
        }
    }
}



#Preview {
    VStack {
        MedalView(medalType: "person", medalColor: .bronze)
        MedalView(medalType: "person", medalColor: .silver)
        MedalView(medalType: "person", medalColor: .gold)
        MedalView(medalType: "person", medalColor:.emerald)
        MedalView(medalType: "person",medalColor:.diamond)
    }
}
