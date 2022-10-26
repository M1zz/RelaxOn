//
//  CDPlayViewModel.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI

class CDPlayViewModel: ObservableObject {
    @Published var playingCD: CD?
    @Published var cdManager: CDManager?

    func clickedplayPause() {
        cdManager?.playPause()
    }

    func clickedPreCD() {
        cdManager?.playPreCD()
    }

    func clickedNextCD() {
        cdManager?.playNextCD()
    }

    func volumeControl() {
    }

    func namingCD() {
    }
    
    func setUp(playingCD: CD, cdManager: CDManager) {
        self.playingCD = playingCD
        self.cdManager = cdManager
    }
}
