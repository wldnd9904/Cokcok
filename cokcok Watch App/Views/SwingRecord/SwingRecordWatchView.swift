import SwiftUI
import CoreMotion

struct SwingRecordWatchView: View {
    @StateObject var model = SwingRecordViewModelWatch()
    var body: some View {
        ZStack{
            Image(uiImage: model.livePreviewImageView)
                .resizable().ignoresSafeArea()
                .rotationEffect(Angle(degrees: 90))
                .scaleEffect(x: -1, y: 1)
            VStack {
                Text("Pitch: \(model.record.last?.attitude.pitch ?? "0")")
                Text("Yaw: \(model.record.last?.attitude.yaw ?? "0")")
                Text("Roll: \(model.record.last?.attitude.roll ?? "0")")
                Text("Data Length: \(model.record.count)")
                Button(action: {
                    if !model.isRecording {
                        model.startRecording()
                    } else {
                        model.stopRecording()
                    }
                }) {
                    Text(model.isRecording ? "Stop Recording" : "Start Recording")
                }
            }
        }.onDisappear(perform: {
            model.stopRecording()
        })
        .navigationBarBackButtonHidden(model.isRecording)
    }
}

#Preview {
    SwingRecordWatchView()
}
