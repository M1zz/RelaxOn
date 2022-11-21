//
//  AudioMaterialManager.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/11/15.
//

import Foundation

final class AudioMaterialManager {
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var whiteNoiseAudioManager = AudioManager()
    
    func setUpMaterials(CD: CD) {
        baseAudioManager.startPlayer(track: CD.base?.fileName ?? "base_default", volume: CD.base?.audioVolume ?? 0.8)
        melodyAudioManager.startPlayer(track: CD.melody?.fileName ?? "base_default", volume: CD.melody?.audioVolume ?? 0.8)
        whiteNoiseAudioManager.startPlayer(track: CD.whiteNoise?.fileName ?? "base_default", volume: CD.whiteNoise?.audioVolume ?? 0.8)
    }
    
    func playPause() {
        baseAudioManager.playPause()
        melodyAudioManager.playPause()
        whiteNoiseAudioManager.playPause()
    }
}
