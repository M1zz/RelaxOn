//
//  TimerManager.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/10.
//

import Foundation


class TimerManager: ObservableObject {
    static let shared = TimerManager()
    
    @Published var musicTimer = MusicTimer()
    var musicViewModel = MusicViewModel.shared

    var timerOn: Bool {musicTimer.timerOn}
    
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
    
    func start(time: Int) {
        musicTimer.setTime(second: time)
        musicTimer.timerOn = true
    }
    
    func endMusicAndTimer() {
        musicTimer.timerOn = false
        musicViewModel.stop()
        musicViewModel.isPlaying = false
    }
    
    func toggleTimerStop() {
        musicTimer.timerStop.toggle()
    }
}
