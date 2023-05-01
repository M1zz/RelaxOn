//
//  TimerProgressView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/26.
//

import SwiftUI

struct TimerProgressView: View {

    @State var timer: Timer?
    @ObservedObject var timeData = Time()
    @State var remainingSeconds: Int = 0
    @State var isShowingTimerProgressView: Bool = false
    @Binding var progress: Double

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
                .foregroundColor(.gray)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.black)
                .rotationEffect(Angle(degrees: 270.0))

        }
    }
}
