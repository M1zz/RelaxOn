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
    var countItem = 5
    
    init(width: CGFloat) {
        self.width = width
    }
    
    var body: some View {

        VStack {
            ZStack {
                
                Circle()
                    .stroke(Color.systemGrey2, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .frame(width: width)
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.systemGrey3)
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: angle))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                    })
                )
            }
        }
    }
    
/**
 슬라이더의 각도를 구하는 함수
 수평선을 기준으로 상단은 + 180, 하단은 -180
 SnappedAngle은 정해진 각도로만 이동하기위한 함수
 */
    // TODO: 각도별로 이동하는 기능과 슬라이딩으로 이동하는 기능 각각 구현
    func onDrag(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy, vector.dx)
        let angle = radians * 180 / .pi
        let snappedAngle = round(angle / 72) * 72
        self.angle = Double(snappedAngle)
        print("\(angle)")
    }
}

struct CircularSlider_Previews: PreviewProvider {
    static var previews: some View {
        CircularSlider(width: 300)
    }
}
