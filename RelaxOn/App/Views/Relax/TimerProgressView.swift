//
//  TimerProgressView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/26.
//

import SwiftUI

/**
 타이머가 작동되는 동안의 View
 */
struct TimerProgressView: View {

    @State var timer: Timer?
    @ObservedObject var timeData: TimerManager
    @State var remainingSeconds: Int = 0
    @State var isShowingTimerProgressView: Bool = false
    @Binding var progress: Double

    // TODO: 타이머 작동 관련 로직이 TimerManager에서 관리되고, View에서는 최대한 보이지 않도록 하는게 좋을 것 같습니다.
    func startTimer() {
        remainingSeconds = timeData.selectedTimeIndexHours * 3600 + timeData.selectedTimeIndexMinutes * 60

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remainingSeconds -= 1

            if remainingSeconds <= 0 {
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
            // TODO: View 파일 내에서는 계산식이 보이지 않도록 수정 필요
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

/**
 원형 프로그래스 바 View
 타이머가 작동되고 있는 동안 남아있는 시간을 시각적으로 보여주는 기능
 */
// TODO: CircleProgressBarView 로 네이밍 수정 -> 모델 객체로 보일 수 있음
struct CircleProgressBar: View {

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
