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
        VStack(alignment: .center) {
            if(!model.isReachable) {
                VStack{
                    HStack{
                        Spacer()
                        Text("\(model.isReachable ? "": "애플워치가 연결되지 않았습니다.")")
                        Spacer()
                    }
                    Button(action: {
                        HKHealthStore().startWatchApp(with: HKWorkoutConfiguration(), completion: {_,_ in })
                    }) {
                        Text("애플워치에서 콕콕 앱 열기")
                    }
                }
                .background(.red.opacity(0.7))
            }
            ZStack {
                VStack{
                    Text("카메라를 사용할 수 없습니다.")
                }
                model.preview
                VStack {
                    Spacer()
                    HStack{
                        if(model.isReachable){
                            Button(action: {
                                model.state == .idle ? model.startRecording(): model.stopRecording()
                            })
                            {
                                (model.state == .idle ? Image(systemName: "record.circle") :  Image(systemName: "stop.circle"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                            }
                            .padding()
                            .foregroundColor(.blue)
                        }
                        Button(action: {
                            model.switchCameraInput()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                        .padding()
                        .foregroundColor(.blue)
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                        }
                        .padding()
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
}
#Preview {
    SwingRecordView(dismiss:{})
}
