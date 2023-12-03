//
//  SwingHelpView.swift
//  cokcok
//
//  Created by 최지웅 on 12/3/23.
//

import SwiftUI

struct HelpBalloon{
    let color:Color
    let width:CGFloat
    let height:CGFloat
    let text: String
    let top: Bool
    let left: Bool
    let right: Bool
    let offsetX: CGFloat
    let offsetY: CGFloat
    init(_ color: Color, _ width: CGFloat, _ height: CGFloat, _ text: String, _ top: Bool, _ left: Bool, _ right: Bool, _ offsetX: CGFloat, _ offsetY: CGFloat) {
        self.color = color
        self.width = width
        self.height = height
        self.text = text
        self.top = top
        self.left = left
        self.right = right
        self.offsetX = offsetX
        self.offsetY = offsetY
    }
}


struct SwingHelpView: View {
    let helps: [HelpBalloon] = [HelpBalloon(.white.opacity(0.6), 200, 120, "카메라 전환 버튼을 눌러 전/후면 카메라를 선택합니다.", false, true, true, -25, 250),HelpBalloon(.white.opacity(0.6), 280, 120, "화면 중앙에 본인의 정면 모습이 오도록 카메라를 조정합니다.\n화면에 전신이 담겨야 합니다.", true, true, true, 0, 100), HelpBalloon(.white.opacity(0.6), 250, 120, "애플워치에서 스윙 녹화 페이지를 열어 녹화 버튼이 활성화된 것을 확인합니다.", false, true, true, -85, 250), HelpBalloon(.white.opacity(0.6), 250, 120, "아이폰 또는 애플워치에서 녹화 버튼을 눌러 하이클리어를 1회 녹화합니다.", false, true, true, -85, 250), HelpBalloon(.white.opacity(0.6), 200, 120, "녹화를 종료하고 결과를 확인합니다.", false, true, true, -85, 250),HelpBalloon(.white.opacity(0.6), 200, 120, "X 버튼을 눌러 창을 종료할 수 있습니다.", false, true, false, 10, 250)]
    @State var counter = 0
    let onClose: () -> Void
    var body: some View {
        ZStack{
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            Balloon(color: helps[counter].color, width:helps[counter].width, height:helps[counter].height, text:helps[counter].text, top:helps[counter].top, left:helps[counter].left, right:helps[counter].right) {
                if(counter == helps.count - 1){
                    onClose()
                } else {
                    withAnimation{
                        counter += 1
                    }
                }
            }
                .offset(x:helps[counter].offsetX,y:helps[counter].offsetY)
        }
    }
}
struct TriangleView: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        
        return path
    }
}

struct Balloon: View {
    let color:Color
    let width:CGFloat
    let height:CGFloat
    let text: String
    let top: Bool
    let left: Bool
    let right: Bool
    let onNext: () -> Void
    var body: some View {
        ZStack {
            // 말풍선 모양의 테두리
            VStack(alignment: .leading, spacing:0){
                    HStack{
                        if(left){Spacer()}
                        TriangleView()
                            .foregroundColor(color)
                            .frame(width: 18, height: 12)
                            .padding(.horizontal, 20)
                        if(right){Spacer()}
                    }.frame(width:width)
                        .scaleEffect(x:1, y:-1)
                        .opacity(top ? 1 : 0)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(color)
                    .frame(width: width, height: height)
                    .transition(.opacity)
                
                    HStack{
                        if(left){Spacer()}
                        TriangleView()
                            .foregroundColor(color)
                            .frame(width: 18, height: 12)
                            .padding(.horizontal, 20)
                        if(right){Spacer()}
                    }.frame(width:width)
                    .opacity(top ? 0 : 1)
            }
            // 설명 내용
            Text(text)
                .padding()
                .multilineTextAlignment(.center)
                .transition(.opacity)
                .frame(width: width, height: height)
            Button{onNext()} label:{
                Image(systemName: "play.circle")
                    .foregroundColor(.black)
                    .padding()
            }
            .frame(width:width, height:height, alignment: .bottomTrailing)
        }
    }
}
#Preview {
    SwingHelpView(onClose:{})
}
