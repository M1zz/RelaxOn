//
//  CDPlayViewModel.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI

final class CDPlayViewModel: ObservableObject {
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
    
    func setUp(cdManager: CDManager) {
        self.cdManager = cdManager
    }
}
