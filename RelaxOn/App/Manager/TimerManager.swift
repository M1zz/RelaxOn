//
//  TimerManager.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/26.
//

import Foundation

/**
 Timer의 시간을 감지하는 객체
 */
class TimerManager: ObservableObject {
    
    @Published var selectedTimeIndexHours: Int = 0
    @Published var selectedTimeIndexMinutes: Int = 0
    @Published var remainingSeconds: Int = 0
    @Published var timer: Timer?
    
    func startTimer(manager: TimerManager, timer: Timer?) {
        
        manager.remainingSeconds = getTime(manager: manager)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            manager.remainingSeconds -= 1
            
            if manager.remainingSeconds <= 0 {
                timer.invalidate()
                manager.remainingSeconds = 0
            }
        }
        func getTime(manager: TimerManager) -> Int {
            let manager = manager
            var hour = manager.selectedTimeIndexHours
            var minute = manager.selectedTimeIndexMinutes
            
            hour = hour * 3600
            minute = minute * 60
            
            return hour + minute
        }
    }
    
    func stopTimer(manager: TimerManager, timer: Timer?) {
        timer?.invalidate()
        manager.remainingSeconds = 0
    }
}
