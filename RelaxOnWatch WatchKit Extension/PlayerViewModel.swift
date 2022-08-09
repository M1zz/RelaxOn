//
//  PlayerViewModel.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import MediaPlayer
import Combine
import AVFoundation


class PlayerViewModel: ObservableObject {
    @Published var playState: PlayStates = .pause
    @Published var currentCDName = "Not playing"
    
    @Published var isPlaying = false
    @Published var cdinfos: [String] = ["false", ""]
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        Connectivity.shared.$cdInfos
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .assign(to: \.cdinfos, on: self)
            .store(in: &cancellable)
    }
    
    func playPause() {
        self.isPlaying = !isPlaying
        updateCompanion(info: isPlaying ? "playing" : "paused")
    }
    
    func playPrevious() {
        self.playState = .backward
        updateCompanion(info: "prev")
    }
    
    func playNext() {
        self.playState = .forward
        updateCompanion(info: "next")
    }
    
    func updateCompanion(info: String) {
        Connectivity.shared.sendFromWatch(watchInfo: info)
    }
}
