//
//  CDPlayerViewModel.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/27.
//

import SwiftUI

final class CDPlayerViewModel: ObservableObject {
    @Published var currentCDName = CDPlayerManager.shared.currentCDName
    @Published var isPlaying = CDPlayerManager.shared.isPlaying
    
    var cdPlayerManager = CDPlayerManager.shared
    
    func getSystemVolume() {
        cdPlayerManager.requestVolume()
    }
    
    func playPrevious() {
        cdPlayerManager.playPrevious()
    }
    
    func playPause() {
        cdPlayerManager.playPause()
    }
    
    func isPlayerEmpty() -> Bool {
        return currentCDName == ""
    }
    
    func getIconName() -> String {
        return cdPlayerManager.isPlaying ? "pause.fill" : "play.fill"
    }
    
    func playNext() {
        cdPlayerManager.playNext()
    }
}
