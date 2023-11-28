//
//  SwingRecordView.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import SwiftUI
import HealthKit

struct SwingRecordView: View {
    @StateObject var model = SwingRecordManagerPhone()
    let dismiss: () -> Void
    var body: some View {
        if(model.state == .sent){
            Text("결과페이지")
        } else {
            ZStack {
                Text("카메라를 사용할 수 없습니다.")
                model.preview
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack(spacing:20){
                        Button(action: {
                            model.state == .running ? model.stopRecording(): model.startRecording()
                        }){
                            Image(systemName: model.state == .running ? "stop.circle" : "record.circle")
                        }
                        .disabled(!model.isReachable ||
                                  model.state.isError())
                        Button(action: {
                            model.switchCameraInput()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                        }
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle")
                        }
                        .foregroundColor(model.isButtonActivated ? .red : .gray)
                    }
                    .disabled(!model.isButtonActivated)
                    .padding(10)
                    .font(.title)
                    .background(.white)
                    .cornerRadius(30)
                    .shadow(radius: 3)
                }
                
                VStack(alignment: .center) {
                    if(!model.isReachable) {
                        HStack{
                            Spacer()
                            VStack{
                                if !model.isReachable {
                                    Text("애플워치가 연결되지 않았습니다.")
                                    Button(action: {
                                        model.startCokcokWatchApp()
                                    }) {
                                        Text("애플워치에서 콕콕 열기")
                                    }
                                }
                            }
                            .padding(.bottom, 7)
                            Spacer()
                        }
                        .background(Color(red: 238/255, green: 126/255, blue: 115/255))
                    }
                    if(model.state != .idle) {
                        HStack{
                            Spacer()
                            Text(model.state.message)
                                .padding(3)
                            Spacer()
                        }
                        .background(Color(red:249/255, green: 221/255, blue:102/255))
                    }
                    Spacer()
                }
                .animation(.easeIn, value: model.state)
            }
        }
    }
}
#Preview {
    SwingRecordView(dismiss:{})
}
