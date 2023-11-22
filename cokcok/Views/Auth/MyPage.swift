//
//  MyPage.swift
//  cokcok
//
//  Created by 최지웅 on 11/22/23.
//

import SwiftUI

struct MyPage: View {
    enum Hand: String, CaseIterable, Identifiable {
        var id: String {rawValue}
        case left = "왼손"
        case right = "오른손"
    }
    enum Sex: String, CaseIterable, Identifiable {
        var id: String {rawValue}
        case male = "남성"
        case female = "여성"
        case etc = "기타"
    }
    enum Grade: String, CaseIterable, Identifiable {
        var id: String {rawValue}
        case jagang = "자강조"
        case a = "A조"
        case b = "B조"
        case c = "C조"
        case d = "D조"
        case beginner = "초심"
    }
    enum ColorTheme: String, CaseIterable, Identifiable {
        var id: String {rawValue}
        case light = "밝은 모드"
        case dark = "어두운 모드"
        case system = "시스템 설정에 맞춤"
    }
    
    @EnvironmentObject var authManager: AuthenticationManager
    @Binding var isPresented: Bool
    @State var editMode:Bool = false
    @State var hand: Hand = .right
    @State var sex: Sex = .male
    @State var grade: Grade = .c
    @State var theme: ColorTheme = .system
    var body: some View {
        ZStack(alignment:.top){
            List {
                Section(header: Text("계정").font(.headline)) {
                    HStack{
                        Text("계정 제공자")
                        Spacer()
                        Image("google")
                        Text("Google")
                    }
                    HStack{
                        Text("이메일")
                        Spacer()
                        Text("wldnd9904@uos.ac.kr")
                    }
                    Button("로그아웃") {
                        isPresented = false
                        authManager.signOut()
                    }
                    .foregroundColor(.red)
                }
                Section(header:HStack{
                    Text("내 정보").font(.headline)
                    Spacer()
                    Button(editMode ? "저장":"수정"){
                        editMode.toggle()
                    }
                    .foregroundColor(.blue)
                    if editMode {
                        Button("취소"){
                            editMode.toggle()
                        }
                        .foregroundColor(.blue)
                    }
                }
                        , footer:Text("위 정보는 스윙을 분석할 때 사용됩니다.")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.gray)){
                        if editMode {
                            Picker("급수", selection: $grade) {
                                ForEach(Grade.allCases) { grade in
                                    Text(grade.rawValue).tag(grade)
                                }
                            }
                            Picker("성별", selection: $sex) {
                                ForEach(Sex.allCases) { sex in
                                    Text(sex.rawValue).tag(sex)
                                }
                            }
                            Picker("라켓 잡는 손", selection: $hand) {
                                ForEach(Hand.allCases) { hand in
                                    Text(hand.rawValue).tag(hand)
                                }
                            }
                        } else {
                            HStack{Text("급수")
                                Spacer()
                                Text(grade.rawValue).foregroundStyle(.gray)
                            }
                            
                            HStack{Text("성별")
                                Spacer()
                                Text(sex.rawValue).foregroundStyle(.gray)
                            }
                            
                            HStack{Text("라켓 잡는 손")
                                Spacer()
                                Text(hand.rawValue).foregroundStyle(.gray)
                            }
                        }
                    }
                
                Section(header: Text("앱 설정").font(.headline)) {
                    Picker("화면 모드", selection: $theme) {
                        ForEach(ColorTheme.allCases) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    Button("캐시 삭제"){}
                }
                
                Section(header: Text("이용 안내").font(.headline)) {
                    HStack{
                        Text("앱 버전")
                        Spacer()
                        Text("0.1")
                            .foregroundStyle(.gray)
                    }
                    Text("문의하기")
                    Text("앱 사용 설명서")
                    Text("개인정보 처리방침")
                }
                
                Section(header: Text("기타").font(.headline)) {
                    Button("데이터 초기화"){}
                        .foregroundColor(.red)
                    Button("회원 탈퇴"){}
                        .foregroundColor(.red)
                }
            }
            .foregroundColor(.primary)
            
                Capsule()
                    .fill(Color.secondary)
                    .opacity(0.5)
                    .frame(width: 35, height: 5)
                    .padding(6)
        }
    }
}

#Preview {
    MyPage(isPresented: .constant(true))
        .environmentObject(AuthenticationManager())
}
