//
//  CircularSlider.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/05/25.
//
/**
 원하는 width 크기만큼의 원형 슬라이더를 만드는 View 객체
 SoundDetailView의 원형 슬라이더로
 사운드 커스텀에 사용되는 슬라이더
 */

import SwiftUI

struct CircularSlider: View {
    @State var angle: Double = Double.random(in: 0...360)
    @State var width: CGFloat
    var imageName: String
    // 버튼 움직임 타입: 2가지 (슬라이드, 이동)
    var gestureType: Bool = true
    var angleChanged: (Double) -> Void
    
    // 슬라이더의 angle값을 반환
    init(width: CGFloat, imageName: String, gestureType: Bool, angleChanged: @escaping (Double) -> Void) {
            self.width = width
            self.imageName = imageName
            self.gestureType = gestureType
            self.angleChanged = angleChanged
        }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 24)
            .foregroundColor(Color.systemGrey3)
            .rotationEffect(.init(degrees: -angle))
            .offset(x: width / 2)
            .rotationEffect(.init(degrees: angle))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        if gestureType {
                            onDrag(value: value)
                        } else {
                            onMove(value: value)
                        }
                    })
            )
    }
    
    /**
     슬라이더의 각도를 구하는 함수
     수평선을 기준으로 상단은 + 180, 하단은 -180
     SnappedAngle은 정해진 각도로만 이동하기위한 함수
     */
    // 슬라이드형 움직임
    func onDrag(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy, vector.dx)
        let angle = radians * 180 / .pi
        self.angle = angle
        angleChanged(angle)
        print("\(angle)")
    }
    // 이동형 움직임
    func onMove(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy, vector.dx)
        let angle = radians * 180 / .pi
        let snappedAngle = round(angle / 72) * 72
        self.angle = Double(snappedAngle)
        angleChanged(angle)
        print("\(angle)")
    }
}

// 배경으로 쓰이는 원 + 원형 라인 + 이동 포인트
@ViewBuilder
func backgroundCircle() -> some View {
    
    ZStack {
        Circle()
            .fill(Color.relaxDimPurple)
            .frame(width: 300)
            .opacity(0.3)
        Circle()
            .stroke(style: .init(lineWidth: 1))
            .foregroundColor(.relaxDimPurple)
            .frame(width: 80)
        Image(FeatureIcon.headset.rawValue)
            .resizable()
            .scaledToFit()
            .frame(width: 26)
        ForEach(0..<circleWidth.count) { index in
            Circle()
                .stroke(style: .init(lineWidth: 1))
                .foregroundColor(.relaxDimPurple)
                .frame(width: circleWidth[index])
        }
        ForEach(0..<pointAngle.count) { index in
            Circle()
                .frame(width: 6)
                .foregroundColor(.purple)
                .offset(x: 300 / 2)
                .rotationEffect(.init(degrees: pointAngle[index]))
        }
    }
}
struct CircularSlider_Previews: PreviewProvider {
    static var previews: some View {
        CircularSlider(width: 300, imageName: "filter", gestureType: true) { angle in
            // 해당 예시처럼 값을 활용해볼 예정
            print("Selected angle: \(angle / 10)")
        }
    }
}
