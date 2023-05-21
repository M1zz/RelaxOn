//
//  CircleProgressView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 원형 프로그래스 바 View
 타이머가 작동되고 있는 동안 남아있는 시간을 시각적으로 보여주는 기능
 */
struct CircleProgressView: View {
    
    @Binding var progress: Double
    @EnvironmentObject var timeData: TimerManager
    @State var timer: Timer?
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.black)
                .rotationEffect(Angle(degrees: 270.0))
            
        }
    }
}

struct CircleProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircleProgressView(progress: .constant(0.5))
    }
}