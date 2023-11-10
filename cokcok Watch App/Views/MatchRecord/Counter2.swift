//
//  Counter2.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/10/23.
//

import SwiftUI

struct Counter2: View {
    let score: Int
    let color:Color
    let incrementVar: () -> Void
    let decrementVar: () -> Void
    let resetVar: () -> Void
    
    var body: some View {
        ZStack {
            color
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack{
                    Button(action:incrementVar) {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                            .opacity(0.5)
                            .padding()
                    }.buttonStyle(.plain)
                    
                    Spacer()
                    
                    Text("\(score)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .onTapGesture(perform:incrementVar)
                
                Button(action:decrementVar) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .opacity(0.5)
                        .padding()
                }.buttonStyle(.plain)
                
                Spacer(minLength: 20)
            }
        }
    }
}

#Preview {
    HStack(spacing:5) {
        Counter2(score: (20), color: .blue, incrementVar: {
            print("Increment Button Pressed")
        }, decrementVar: {
            print("Decrement Button Pressed")
        }, resetVar: {})
        Counter2(score: (10), color: .red, incrementVar: {
            print("Increment Button Pressed")
        }, decrementVar: {
            print("Decrement Button Pressed")
        }, resetVar: {})
    }
}
