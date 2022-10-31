//
//  CDManager.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI
import AVFoundation

final class CDManager: ObservableObject {
    @Published var isPlayed: Bool = false
    @Published var CDList: [CD] = []
    @Published var playingCD: CD?
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var whiteNoiseAudioManager = AudioManager()
    
    init(playingCD: CD? = nil) {
        self.playingCD = playingCD
        self.baseAudioManager.startPlayer(track: BaseSound.longSun.fileName)
        self.melodyAudioManager.startPlayer(track: MelodySound.garden.fileName)
        self.whiteNoiseAudioManager.startPlayer(track: WhiteNoiseSound.dryGrass.fileName)
    }
    
    func playPause() {
        print(#function)
        baseAudioManager.playPause()
        melodyAudioManager.playPause()
        whiteNoiseAudioManager.playPause()
    }

    func playTempCD() {
        print(#function)
    }

    func playPreCD() {
        print(#function)
    }

    func playNextCD() {
        print(#function)
    }

    func addCD() {
        print(#function)
    }

    func removeCd() {
        print(#function)
    }

    func namingCD() {
        print(#function)
    }
}



