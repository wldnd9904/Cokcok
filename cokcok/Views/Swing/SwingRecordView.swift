//
//  SwingRecordView.swift
//  cokcok
//
//  Created by 최지웅 on 11/6/23.
//

import SwiftUI

struct SwingRecordView: View {
    @StateObject var model = SwingRecordViewModelPhone()
    
    var body: some View {
        VStack(alignment: .center) {
            Text("애플워치: \(model.wcsession.isReachable ? "연결됨": "연결되지 않음")")
            Text(model.errorMessage)
            ZStack {
                model.preview?
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack{
                        Button(action: {
                            model.isRecording ? model.stopRecording() : model.startRecording()
                        }) {
                            model.isRecording ? Text("정지") : Text("시작")
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        Button(action: {
                            model.switchCameraInput()
                        }) { Text("전환")}
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
}
#Preview {
    SwingRecordView()
}
