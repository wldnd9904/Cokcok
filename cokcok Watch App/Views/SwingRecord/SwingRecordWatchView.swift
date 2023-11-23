import SwiftUI
import CoreMotion

struct SwingRecordWatchView: View {
    @StateObject var model = SwingRecordManagerWatch()
    var body: some View {
        ZStack{
            Image(uiImage: model.livePreviewImageView)
                .resizable().ignoresSafeArea()
                .rotationEffect(Angle(degrees: 90))
                .scaleEffect(x: -1, y: 1)
            VStack {
                Text("Data Length: \(model.recordedMotion.count)")
                Button(action: {
                    if model.state == .idle {
                        model.startRecording()
                    } else {
                        model.stopRecording()
                    }
                }) {
                    Text(model.state == .running ? "Stop Recording" : "Start Recording")
                }
            }
        }.onDisappear(perform: {
            model.stopRecording()
        })
        .navigationBarBackButtonHidden(model.state == .running)
    }
}

#Preview {
    SwingRecordWatchView()
}
