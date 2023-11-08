//
//  Counter.swift
//  Badminton Score Counter WatchKit Extension
//
//  Created by 최지웅 on 2022/09/13.
//

import SwiftUI



struct Counter: View {
    let score: Int
    let color:Color
    let incrementVar: () -> Void
    let decrementVar: () -> Void
    let resetVar: () -> Void
    var body: some View {
        VStack{
            HStack{
                Button(action:incrementVar){
                    Text("\(score)").font(.title2)
                        .foregroundColor(.white)
                }
                .cornerRadius(10)
                .buttonStyle(.borderless)
                .frame(width:60,height:45)
                .overlay(RoundedRectangle(cornerRadius:10).stroke(Color.gray, lineWidth: 1))
                VStack{
                    Button(action:incrementVar){
                        Text("+")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderless)
                    .frame(width:30,height:20)
                    .background(color)
                    .cornerRadius(5)
                    Button(action:decrementVar){
                        Text("-")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderless)
                    .frame(width:30,height:20)
                    .background(color)
                    .cornerRadius(5)
                }
            }
            Button(action:resetVar){
                Text("           ")
            }.buttonStyle(.borderless)
                .frame(width:95, height:1)
                .background()
                .shadow(color:.white, radius:3, y:2)
                
        }
    }
}

#Preview {
    Counter(score: (20), color: .red, incrementVar: {
        print("Increment Button Pressed")
    }, decrementVar: {
        print("Decrement Button Pressed")
    }, resetVar: {})
}
