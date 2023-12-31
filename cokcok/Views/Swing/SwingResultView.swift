//
//  SwingResultView.swift
//  cokcok
//
//  Created by 최지웅 on 12/1/23.
//

import SwiftUI
import AVKit

struct SwingResultView: View {
    let folderName: String
    @State var video: AVPlayer? = nil
    @Binding var state: SwingRecordManagerPhoneState
    let onAccept:() -> Void
    let onCancel:() -> Void
    var body: some View {
        VStack(){
            HStack{
                Spacer()
                Text(state.message)
                Spacer()
            }
            .padding(.bottom, 7)
            .background(.green.opacity(0.6))
            Spacer()
            VideoPlayer(player: video)
            Spacer()
            Text("이 영상으로 실력을 측정할까요?")
            HStack{
                Button("확인"){onAccept()}
                    .tint(.blue)
                Button("취소"){onCancel()}
                    .tint(.red)
            }
            .disabled(state == .sending)
            .font(.headline)
            .buttonStyle(.bordered)
        }
        .onAppear{
            let fileManager = FileManager.default
            guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
            let filePath = documentsURL.appendingPathComponent(self.folderName).appendingPathComponent("Video.mp4")
            video = AVPlayer(url: filePath)
        }
    }
}

#Preview {
    SwingResultView(folderName:"", state: .constant(.idle)) {} onCancel: {
        
    }
}
