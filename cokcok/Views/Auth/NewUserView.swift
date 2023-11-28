//
//  NewUserView.swift
//  cokcok
//
//  Created by 최지웅 on 11/28/23.
//

import SwiftUI

struct NewUserView: View {
    @StateObject var manager: NewUserManager = NewUserManager(id: "sdf", email: "heung@never.com", authType: .kakao)
    var body: some View {
        VStack(alignment: .center){
            if(manager.showMessage){
                Text(manager.question.message)
                    .font(.title2)
                    .bold()
            }
            if(manager.showSelection){
                VStack{
                    switch(manager.question){
                    case .gender:
                        HStack{
                            Selection(text: "남성", onSelect: manager.next, color:.blue)
                            Selection(text: "여성", onSelect: manager.next, color:.red)
                            Selection(text: "기타", onSelect: manager.next, color:.black)
                        }
                    case .hand:
                        HStack{
                            Selection(text: "왼손", onSelect: manager.next, color:.blue)
                            Selection(text: "오른손",onSelect: manager.next, color:.red)
                        }
                    case .year:
                        HStack{
                            Picker("", selection: $manager.selected) {
                                Text("1년 미만").tag(0)
                                ForEach(1...20, id: \.self) {
                                    Text("\($0)년").tag($0)
                                }
                                Text("20년 이상").tag(21)
                            }
                            .frame(width:150, height:100)
                            .pickerStyle(.wheel)
                            Button("선택", action:manager.next)
                                .buttonStyle(.bordered)
                                .tint(.blue)
                        }
                    case .grade:
                        HStack{
                            Picker("", selection: $manager.selected) {
                                Text("초심").tag(0)
                                Text("D급").tag(1)
                                Text("C급").tag(2)
                                Text("B급").tag(3)
                                Text("A급").tag(4)
                                Text("자강조").tag(5)
                            }
                            .frame(width:150, height:100)
                            .pickerStyle(.wheel)
                            Button("선택", action:manager.next)
                                .buttonStyle(.bordered)
                                .tint(.blue)
                        }
                    case .done:Button("시작하기"){}
                    default:Text("")
                    }
                    if(manager.question.rawValue > 2) {
                        Button("이전", action: manager.prev)
                    }
                }
            }
        }
        .animation(.easeIn, value: manager.showMessage)
        .animation(.easeIn, value: manager.showSelection)
        .onAppear{
            manager.start()
        }
    }
}

struct Selection: View {
    let text: String
    let onSelect:() -> Void
    let color:Color
    var body: some View {
        Button(action: onSelect){
            Text(text)
                .frame(width:50,height:50)
                .bold()
        }
        .buttonStyle(.bordered)
        .tint(color)
    }
}

#Preview {
    NewUserView()
}
