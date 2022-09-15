//
//  CDPlayerManager.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/11.
//

import UIKit

import AVFoundation

final class CDPlayerManager: ObservableObject {
    
    // MARK: - singleton
    static let shared = CDPlayerManager()

    @Published var isPlaying = false
    @Published var currentCDName = ""
    
    func playPause() {
        if isPlaying {
            isPlaying = false
            WatchConnectivityManager.shared.sendMessage(key: "player", "pause")
        } else {
            isPlaying = true
            WatchConnectivityManager.shared.sendMessage(key: "player", "play")
        }
    }

    func playPrevious() {
        WatchConnectivityManager.shared.sendMessage(key: "player", "prev")
    }
    
    func playNext() {
        WatchConnectivityManager.shared.sendMessage(key: "player", "next")
    }
}
