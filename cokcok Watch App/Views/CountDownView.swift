//
//  CountDownView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/12/23.
//

import SwiftUI

struct CountDownView: View {
    let count: Int
    let color: Color
    @State var countdown: Int = 100
    let onEnd: () -> Void
    var body: some View {
        ZStack {
            if countdown == 100 {
                Button {
                    withAnimation(.easeOut(duration:0.3)) {
                        countdown = count
                    }
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        withAnimation(.easeOut(duration:0.3)) {
                            if self.countdown > 1 {
                                self.countdown -= 1
                            } else {
                                self.countdown = 0
                                DispatchQueue.main.async {
                                    onEnd()
                                }
                                timer.invalidate()
                            }
                        }
                    }
                } label: {
                    Text("터치하여 시작")
                        .font(.title3)
                        .bold()
                }
                .buttonStyle(.plain)
                .frame(width:130, height:130)
            } else {
                Text("\(countdown)")
                    .font(Font.system(.largeTitle).monospacedDigit())
                    .foregroundColor(.white)
            }
            Circle()
                .stroke(lineWidth: 15)
                .foregroundColor(Color(.darkGray))
                .padding(10)
            Circle()
                .trim(from: 0, to: CGFloat(countdown) / CGFloat(count))
                .stroke(style: StrokeStyle(lineWidth: 13, lineCap: .round, lineJoin: .round))
                .rotation(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .foregroundColor(Color(color))
                .padding(10)
        }
    }
}

#Preview {
    CountDownView(count: 3, color: .red) {print("hi")}
}
