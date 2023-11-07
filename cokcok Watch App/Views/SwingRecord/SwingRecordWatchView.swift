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
                Text("Pitch: \(model.record.last?.attitude.pitch ?? "")")
                Text("Yaw: \(model.record.last?.attitude.yaw ?? "")")
                Text("Roll: \(model.record.last?.attitude.roll ?? "")")
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
        }
    }
}

#Preview {
    SwingRecordWatchView()
}
