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
        WatchConnectivityManager.shared.sendMessage(key: MessageKey.requestVolume, StringLiteral.volume)
    }
    
    func playPrevious() {
        WatchConnectivityManager.shared.sendMessage(key: MessageKey.player, StringLiteral.prev)
    }
    
    func playPause() {
        isPlaying = !isPlaying
        CDPlayer.shared.isPlaying = isPlaying
        if isPlaying {
            WatchConnectivityManager.shared.sendMessage(key: MessageKey.player, StringLiteral.pause)
        } else {
            WatchConnectivityManager.shared.sendMessage(key: MessageKey.player, StringLiteral.play)
        }
    }
    
    func playNext() {
        WatchConnectivityManager.shared.sendMessage(key: MessageKey.player, StringLiteral.next)
    }
    
    func isPlayerEmpty() -> Bool {
        return currentCDName == ""
    }
    
    func changeVolume(volume: Float) {
        CDPlayer.shared.volume = volume
        WatchConnectivityManager.shared.sendMessage(key: MessageKey.changeVolume, String(volume))
    }
}
