//
//  CircleSlider.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/22.
//

import SwiftUI

/**
 원하는 width 크기만큼의 원형 슬라이더를 만드는 View 객체
 */
struct CircleSlider: View {
    
    @State var angle: Double = Double.random(in: 0...360)
    @State var width: CGFloat
    
    init(width: CGFloat) {
        self.width = width
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                
                Circle()
                    .stroke(Color("SystemGrey2"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .frame(width: width)
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("SystemGrey3"))
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
    
    func onDrag(value: DragGesture.Value) {
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        self.angle = Double(angle)
    }
}


struct CircleSlider_Previews: PreviewProvider {
    static var previews: some View {
        CircleSlider(width: 200)
    }
}
