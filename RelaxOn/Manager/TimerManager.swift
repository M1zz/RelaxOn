//
//  TimerManager.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/31.
//

import Foundation

final class TimerManager: ObservableObject {
    
    static let shared = TimerManager()
    
    @Published var musicTimer = MusicTimer()
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.musicTimer.timerOn {
                if !self.musicTimer.timerStop {
                    self.countDown()
                }
            } else {
                // TODO: 음악 종료 함수 추가
                print("음악 종료")
            }
        }
    }
        
    var isOn: Bool {musicTimer.timerOn}
        
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
