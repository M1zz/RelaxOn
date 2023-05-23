//
//  TimeTextView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/05/24.
//

/**
 TimePicker에서 고른 시간과
 남은 시간을 숫자로 알려주는 View
 */

import SwiftUI

struct TimeText: View {
    
    @ObservedObject var timerManager: TimerManager
    
    var body: some View {
        
        Text(String(format: "%02d:%02d:%02d", max(timerManager.remainingSeconds / 3600, 0), max((timerManager.remainingSeconds % 3600) / 60, 0), max(timerManager.remainingSeconds % 60, 0)))
            .font(.system(size: 40))
            .fontWeight(.semibold)
            .padding()
            .onAppear {
                timerManager.startTimer(timerManager: timerManager)
            }
            .onDisappear {
                timerManager.stopTimer(timerManager: timerManager)
            }
    }
}

struct TimeTextView_Previews: PreviewProvider {
    static var previews: some View {
        TimeText(timerManager: TimerManager())
    }
}
