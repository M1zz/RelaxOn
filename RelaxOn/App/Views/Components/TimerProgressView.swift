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
            CircleProgressView(progress: $progress)
            
            // TODO: View 파일 내에서는 계산식이 보이지 않도록 수정 필요
            Text(String(format: "%02d:%02d:%02d", max(remainingSeconds / 3600, 0), max((remainingSeconds % 3600) / 60, 0), max(remainingSeconds % 60, 0)))
                .font(.system(size: 40))
                .fontWeight(.semibold)
                .padding()
                .onAppear {
                    startTimer()
                }
                .onDisappear {
                    resetTimer()
                }
        }
    }
}


struct TimerProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TimerProgressView(timeData: TimerManager(), progress: .constant(0.5))
    }
}
