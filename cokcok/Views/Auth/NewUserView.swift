//
//  NewUserView.swift
//  cokcok
//
//  Created by 최지웅 on 11/28/23.
//

import SwiftUI

struct NewUserView: View {
    @StateObject var manager: NewUserManager
    @State var selectedGrade: Grade = .beginner
    @State var selectedYear: Int = 0
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
                            Selection(text: "남성", onSelect:{
                                manager.next{
                                    manager.sex = .male
                                }
                            }, color:.blue)
                            Selection(text: "여성", onSelect:{
                                manager.next{
                                    manager.sex = .female
                                }
                            }, color:.red)
                            Selection(text: "기타", onSelect:{
                                manager.next{
                                    manager.sex = .etc
                                }
                            }, color:.black)
                        }
                    case .hand:
                        HStack{
                            Selection(text: "왼손",  onSelect:{
                                manager.next{
                                    manager.hand = .left
                                }
                            }, color:.blue)
                            Selection(text: "오른손", onSelect:{
                                manager.next{
                                    manager.hand = .right
                                }
                            }, color:.red)
                        }
                    case .year:
                        HStack{
                            Picker("", selection: $selectedYear) {
                                Text("1년 미만").tag(0)
                                ForEach(1...20, id: \.self) {
                                    Text("\($0)년").tag($0)
                                }
                                Text("20년 이상").tag(21)
                            }
                            .frame(width:150, height:100)
                            .pickerStyle(.wheel)
                            Button("선택", action:{
                                manager.next{
                                    manager.years = selectedYear
                            }})
                                .buttonStyle(.bordered)
                                .tint(.blue)
                        }
                    case .grade:
                        HStack{
                            Picker("", selection: $selectedGrade) {
                                ForEach(Grade.allCases){
                                    Text($0.rawValue).tag($0)
                                }
                            }
                            .frame(width:150, height:100)
                            .pickerStyle(.wheel)
                            Button("선택", action:{
                                manager.next{
                                    manager.grade = selectedGrade
                            }})
                                .buttonStyle(.bordered)
                                .tint(.blue)
                        }
                    case .done:Button("시작하기"){manager.done()}
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
    NewUserView(manager: NewUserManager(id: "sdf", email: "heung@never.com", authType: .kakao){user in
    print(user)})
}
