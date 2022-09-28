//
//  CDPlayerViewModel.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/27.
//

import SwiftUI

final class CDPlayerViewModel: ObservableObject {
    @Published var currentCDName = CDPlayer.shared.currentCDName
    @Published var isPlaying = CDPlayer.shared.isPlaying
    
    func getSystemVolume() {
        WatchConnectivityManager.shared.sendMessage(key: "requestVolume", "volume")
    }
    
    func playPrevious() {
        WatchConnectivityManager.shared.sendMessage(key: "player", "prev")
    }
    
    func playPause() {
        isPlaying = !isPlaying
        CDPlayer.shared.isPlaying = isPlaying
        if isPlaying {
            WatchConnectivityManager.shared.sendMessage(key: "player", "pause")
        } else {
            WatchConnectivityManager.shared.sendMessage(key: "player", "play")
        }
    }
    
    func playNext() {
        WatchConnectivityManager.shared.sendMessage(key: "player", "next")
    }
    
    func isPlayerEmpty() -> Bool {
        return currentCDName == ""
    }
    
    func getIconName() -> String {
        return isPlaying ? "pause.fill" : "play.fill"
    }
    
    func changeVolume(volume: Float) {
        CDPlayer.shared.volume = volume
        WatchConnectivityManager.shared.sendMessage(key: "volume", String(volume))
    }
}
