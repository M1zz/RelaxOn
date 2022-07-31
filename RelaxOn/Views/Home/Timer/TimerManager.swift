//
//  TimerManager.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/31.
//

import Foundation

class TimerManager: ObservableObject {
    
    static let shared = TimerManager()
    
    @Published var musicTimer = MusicTimer()
    
    init() {
        print("timer init")
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.musicTimer.timerOn {
                if !self.musicTimer.timerStop {
                    self.countDown()
                }
                print("남은 시간 \(self.musicTimer.remainedSecond)")
            } else {
                print("음악 종료")
            }
        }
    }
        
    var isOn: Bool {musicTimer.timerOn}
    
    /// 남은 시간 0이 될 경우
    func isShutDown() -> Bool {
        if getRemainedSecond() == 0 {
            return true
        } else {
            return false
        }
    }
    
    /// 1초씩 감소
    func countDown() {
        if musicTimer.remainedSecond > 0 {
            musicTimer.remainedSecond -= 1
        }
    }
    
    func getRemainedSecond() -> Int {
        return musicTimer.remainedSecond
    }
    
    func start(countDownDuration: Double) {
        musicTimer.remainedSecond = Int(countDownDuration)
    }
    
    func stop() {
        musicTimer.timerStop = true
    }
}
