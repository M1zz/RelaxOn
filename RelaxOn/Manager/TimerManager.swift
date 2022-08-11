//
//  TimerManager.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/31.
//

import Foundation

final class TimerManager {
    
    static let shared = TimerManager()
    
    var musicTimer = MusicTimer()
    
    var currentMusicViewModel: MusicViewModel?
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.musicTimer.timerOn {
                if self.musicTimer.remainedSecond <= 0 {
                    if let currentMusicViewModel = self.currentMusicViewModel {
                        currentMusicViewModel.stop()
                    }
                }
                
                if !self.musicTimer.timerStop {
                    self.countDown()
                }
            }
        }
    }
        
    var isOn: Bool {musicTimer.timerOn}
        
    /// 1초씩 감소
    func countDown() {
        if musicTimer.remainedSecond > -1 {
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
