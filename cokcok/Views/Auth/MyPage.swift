//
//  MyPage.swift
//  cokcok
//
//  Created by 최지웅 on 11/22/23.
//

import SwiftUI
import FirebaseAuth

struct MyPage: View {
    @EnvironmentObject var model: ModelData
    @Binding var isPresented: Bool
    @State var editMode:Bool = false
    @State var hand: Hand = .right
    @State var sex: Sex = .male
    @State var grade: Grade = .c
    @State var theme: ColorTheme = .system
    @State var year: Int = 0
    var body: some View {
        ZStack(alignment:.top){
            List {
                Section(header: Text("계정").font(.headline)) {
                    HStack{
                        Text("계정 제공자")
                        Spacer()
                        Text(model.user?.authType.rawValue ?? "")
                            .foregroundColor(.gray)
                    }
                    HStack{
                        Text("이메일")
                        Spacer()
                        Text(model.user?.email ?? "")
                    }
                    Button("로그아웃") {
                        isPresented = false
                        model.signState = .signOut
                        do{
                            try Auth.auth().signOut()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    .foregroundColor(.red)
                }
                Section(header:HStack{
                    Text("내 정보").font(.headline)
                    Spacer()
                    Button(editMode ? "저장":"수정"){
                        model.user?.hand = self.hand
                        model.user?.sex = self.sex
                        model.user?.grade = self.grade
                        model.user?.years = self.year
                        if editMode{
                            Task{
                                do{
                                    try await APIManager.shared.updateUserInfo(token: model.user!.id, sex: model.user!.sex, yearsPlaying: model.user!.years, grade: model.user!.grade, handedness: model.user!.hand, email: model.user!.email, authType: model.user!.authType)
                                } catch{
                                    
                                }
                            }
                        }
                        editMode.toggle()
                    }
                    .foregroundColor(.blue)
                    if editMode {
                        Button("취소"){
                            self.hand = model.user?.hand ?? .right
                            self.sex = model.user?.sex ?? .etc
                            self.grade = model.user?.grade ?? .beginner
                            self.year = model.user?.years ?? 0
                            editMode.toggle()
                        }
                        .foregroundColor(.gray)
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
                            Picker("구력", selection: $year) {
                                Text("1년 미만").tag(0)
                                ForEach(1...20, id: \.self) {
                                    Text("\($0)년").tag($0)
                                }
                                Text("20년 이상").tag(21)
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
                                Text(model.user?.grade.rawValue ?? "").foregroundStyle(.gray)
                            }
                            
                            HStack{Text("구력")
                                Spacer()
                                Text({
                                    switch(model.user?.years ?? 0){
                                    case 0: "1년 미만"
                                    case 21: "20년 이상"
                                    default: "\(model.user?.years ?? 0)년"
                                    }
                                }()
                                ).foregroundStyle(.gray)
                            }
                            
                            HStack{Text("성별")
                                Spacer()
                                Text(model.user?.sex.rawValue ?? "").foregroundStyle(.gray)
                            }
                            
                            HStack{Text("라켓 잡는 손")
                                Spacer()
                                Text(model.user?.hand.rawValue ?? "").foregroundStyle(.gray)
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
        .onAppear{
            self.hand = model.user?.hand ?? .right
            self.sex = model.user?.sex ?? .etc
            self.grade = model.user?.grade ?? .beginner
            self.year = model.user?.years ?? 0
        }
    }
}


#Preview {
    MyPage(isPresented: .constant(true)).environmentObject(ModelData())
}
