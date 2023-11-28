import SwiftUI
import CoreMotion

struct SwingRecordWatchView: View {
    @StateObject var model = SwingRecordManagerWatch()
    var body: some View {
        GeometryReader { geo in
            ZStack{
                Image(uiImage: model.livePreviewImageView)
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: geo.size.width, height: geo.size.height)
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                VStack{
                    VStack(spacing:0){
                        if(!model.isReachable) {
                            HStack{
                                Spacer()
                                Text("스마트폰이 연결되지 않았습니다.")
                                    .foregroundStyle(.black)
                                    .padding(5)
                                Spacer()
                            }
                            .background(Color(red: 238/255, green: 126/255, blue: 115/255))
                        } else {
                            if(model.state != .idle){
                                HStack{
                                    Spacer()
                                    Text(model.state.message)
                                        .foregroundStyle(.black)
                                        .padding(5)
                                    Spacer()
                                }
                                .background(Color(red:249/255, green: 221/255, blue:102/255))
                            }
                        }
                    }
                    .ignoresSafeArea()
                    Spacer()
                    Button(model.state == .running ? "녹화 종료" : " 녹화 시작") {
                        if model.state == .idle {
                            model.startRecording()
                        } else {
                            model.stopRecording()
                        }
                    }
                    .disabled(!model.isReachable)
                }
            }
            .animation(.easeIn, value: model.state)
            .onDisappear(perform: {
                model.stopRecording()
            })
            .navigationBarBackButtonHidden(model.state != .idle && model.state != .ended)
        }
    }
}

#Preview {
    SwingRecordWatchView()
}
