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
    static let shared = PlayerViewModel()
    
    @Published var playState: PlayStates = .pause
    @Published var currentCDName = ""
    
    @Published var isPlaying = false
    @Published var cdinfos: [String] = ["false", ""]
    @Published var cdlist: [String] = [""]
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        Connectivity.shared.$cdInfos
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .assign(to: \.cdinfos, on: self)
            .store(in: &cancellable)
        self.currentCDName = self.cdinfos[1]
        
//        Connectivity.shared.$cdList
//            .dropFirst()
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.cdlist, on: self)
//            .store(in: &cancellable)
    }
    
    func updateCurrentCDName(name: String) {
        self.currentCDName = name
        print("inside updateCurrentCDName: \(self.currentCDName)")
    }
    
    func playPause() {
        self.isPlaying = !isPlaying
        let info = [currentCDName, isPlaying ? "playing" : "paused"]
        updateCompanion(info: info)
    }
    
    func playPrevious() {
        self.playState = .backward
        let info = [currentCDName, "prev"]
        updateCompanion(info: info)
    }
    
    func playNext() {
        self.playState = .forward
        let info = [currentCDName, "next"]
        updateCompanion(info: info)
    }
    
    func updateCompanion(info: [String]) {
        Connectivity.shared.sendFromWatch(watchInfo: info)
    }
}
