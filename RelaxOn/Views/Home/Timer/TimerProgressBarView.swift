//
//  TimerProgressBarView.swift
//  RelaxOn
//
//  Created by hyo on 2022/09/15.
//

import SwiftUI

struct TimerProgressBarView: View {
    @ObservedObject var timerManager = TimerManager.shared
    
    var trimTo: Double {Double(timerManager.getRemainedSecond()) / timerManager.lastSetDurationInSeconds}
    
    var body: some View {
        VStack{
            ProgressBar(trimTo: trimTo)
                .padding(30)
                .overlay {
                    TimeView(remainedSecond: timerManager.getRemainedSecond())
                }
        }
    }
    
    func TimeView(remainedSecond: Int)-> some View {
        VStack {
            Text("Relax for")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.systemGrey2)
            TimeTextView(remainedSecond: remainedSecond)
                .font(.system(size: 50, weight: .semibold))
                .foregroundColor(.systemGrey1)
        }
    }
    
    @ViewBuilder
    func TimeTextView(remainedSecond: Int) -> some View {
        let hour: Int = remainedSecond / 3600
        let minute: Int = (remainedSecond % 3600) / 60
        let seconds: Int = remainedSecond % 60
        
        if hour > 0 {
            Text("\(hour):\(minute, specifier: "%02d"):\(seconds, specifier: "%02d")")
        } else {
            Text("\(minute, specifier: "%02d"):\(seconds, specifier: "%02d")")
        }
    }
}

struct ProgressBar: View {
    var trimTo: Double
    let lineStyle = StrokeStyle(lineWidth: 9, lineCap: .round, lineJoin: .round)
    let rotationDegree: Double = -90
    let gradientColor = LinearGradient(gradient: Gradient(colors: [.relaxNightBlue, .relaxLavender]),
                                       startPoint: .top, endPoint: .bottom)
    var body: some View {
        ZStack {
            // background line
            Circle()
                .stroke(Color.relaxRealBlack, style: lineStyle)
                
            
            // progress line
            Circle().trim(to:trimTo)
                .stroke(gradientColor, style: lineStyle)
                .rotationEffect(.init(degrees: rotationDegree))
        }
    }
}

struct TimerProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        TimerProgressBarView()
            .background(Color.relaxBlack)
    }
}
