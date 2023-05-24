//
//  TimerManager.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/26.
//

import Foundation
import SwiftUI

/**
 Timer의 시간을 감지하는 객체
 */
class TimerManager: ObservableObject {
    
    @Published var selectedTimeIndexHours: Int = 0
    @Published var selectedTimeIndexMinutes: Int = 0
    @Published var remainingSeconds: Int = 0
    @Published var timer: Timer?
    @Published var progress: Double = 1.0
    
    func startTimer(timerManager: TimerManager) {
        
        timerManager.remainingSeconds = getTime(timerManager: timerManager)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerManager.remainingSeconds -= 1
            
            if timerManager.remainingSeconds <= 0 {
                timerManager.stopTimer(timerManager: timerManager)
            }
        }
    }
    
    func getTime(timerManager: TimerManager) -> Int {
        var hour = timerManager.selectedTimeIndexHours
        var minute = timerManager.selectedTimeIndexMinutes
        
        hour = hour * 3600
        minute = minute * 60
        
        return hour + minute
    }
    
    func stopTimer(timerManager: TimerManager) {
        timerManager.timer?.invalidate()
        timerManager.remainingSeconds = 0
        timerManager.progress = 1.0
    }
    
    func getTimeprogressBar(timerManager: TimerManager) {
        let settingTime: Double = Double(timerManager.getTime(timerManager: timerManager))
        var secondPercetage: Double = 0
        secondPercetage = Double((1 / settingTime) * 1.0)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            timerManager.progress -= secondPercetage
            if timerManager.progress <= 0 {
                timerManager.stopTimer(timerManager: timerManager)
            }
        }
    }
    
    func getTimeText(timerManager: TimerManager) -> some View {
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
