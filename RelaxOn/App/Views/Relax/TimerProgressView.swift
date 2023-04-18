//
//  TimerProgressView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/12.
//

import SwiftUI

struct TimerProgressView: View {
    
    @State var timer: Timer?
    @EnvironmentObject var timeData: Time
    @State private var hours : [Int] = Array(1...24)
    @State private var minutes : [Int] = Array(0...59)
    @State var remainingSeconds: Int = 0
    @State var isShowingTimerProgressView: Bool = false
    @Binding var progress: Double
    //설정한 시간
    var totalDurationInSeconds: Double { Double(timeData.selectedTimeIndexHours * 3600 + timeData.selectedTimeIndexMinutes * 60)}
    //시작한 시간
//    var startTime = Date()
//    //경과 시간
//    var currentTime = Date()
//    //남은 시간
//    var elapsedTime = currentTime.timeIntervalSince(startTime)
//    //남은 시간 퍼센트
//    var elapsedTimePercentage =
    
    
    func startTimer() {
        remainingSeconds = timeData.selectedTimeIndexHours * 3600 + timeData.selectedTimeIndexMinutes * 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remainingSeconds -= 1
            
            // 리셋 버튼을 누르면 타이머가 invalidate가 되게 한다면?
            if remainingSeconds <= 0 {
                //invalidate = 타이머를 중지하고 메모리에서 제거
                timer.invalidate()
                remainingSeconds = 0
                isShowingTimerProgressView = false
            }
            
            if isShowingTimerProgressView == false {
                remainingSeconds = 0
            }
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        remainingSeconds = 0
    }
    
    
    var body: some View {
        ZStack {
            CircleProgressBar(progress: $progress)
            Text(String(format: "%02d:%02d:%02d", max(remainingSeconds / 3600, 0), max((remainingSeconds % 3600) / 60, 0), max(remainingSeconds % 60, 0)))
                .font(.system(size: 50))
                .fontWeight(.semibold)
                .padding()
                .onAppear {
                    startTimer()
                }
                .onDisappear {
                    resetTimer()
                }
        }.frame(width: 300, height: 300)
    }
}

struct CircleProgressBar: View {
    
    @Binding var progress: Double
    @EnvironmentObject var timeData: Time
    @State var timer: Timer?
    
    var body: some View {

        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.black)
                .rotationEffect(Angle(degrees: 270.0))
            
        }
    }
}

