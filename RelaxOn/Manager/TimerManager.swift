//
//  TimerManager.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/31.
//

import Foundation
import Combine

final class TimerManager: ObservableObject {
    
    static let shared = TimerManager()
    
    @Published var musicTimer = MusicTimer()
    
    var currentMusicViewModel: MusicViewModel?
    
    @Published var lastSetDurationInSeconds: Double = UserDefaults.standard.double(forKey: "lastSetDurationInSeconds")
    
    private var cancellables = Set<AnyCancellable>()

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
        
        $lastSetDurationInSeconds.sink { newValue in
            UserDefaults.standard.set(newValue, forKey: "lastSetDurationInSeconds")
        }.store(in: &cancellables)
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
    
    func getRemainedMinute() -> Int {
        if self.musicTimer.timerOn == false {
            return Int(lastSetDurationInSeconds / 60)
        } else {
            return musicTimer.remainedSecond / 60
        }
    }
    
    func start(countDownDuration: Double) {
        lastSetDurationInSeconds = countDownDuration
        musicTimer.remainedSecond = Int(countDownDuration)
    }
    
    func stop() {
        musicTimer.timerStop = true
    }
}
