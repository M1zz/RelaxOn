//
//  MusicViewModel.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI
import AVFoundation

final class MusicViewModel: NSObject, ObservableObject {
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var whiteNoiseAudioManager = AudioManager()
    @Published var isPlaying: Bool = false
    
    @Published var mixedSound: MixedSound?
    
    func updateVolume(audioVolumes: (baseVolume: Float, melodyVolume: Float, whiteNoiseVolume: Float)) {
        self.mixedSound?.baseSound?.audioVolume = audioVolumes.baseVolume
        self.mixedSound?.melodySound?.audioVolume = audioVolumes.melodyVolume
        self.mixedSound?.whiteNoiseSound?.audioVolume = audioVolumes.whiteNoiseVolume
    }
    
    func fetchData(data: MixedSound) {
        mixedSound = data
    }
    
    func play() {
        if isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            whiteNoiseAudioManager.playPause()
        } else {
            // play 할 때 mixedSound 볼륨 적용 시도
            baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "base_default", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "base_default", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
            whiteNoiseAudioManager.startPlayer(track: mixedSound?.whiteNoiseSound?.name ?? "base_default", volume: mixedSound?.whiteNoiseSound?.audioVolume ?? 0.8)
        }
    }
    
    func stop() {
        if isPlaying {
            baseAudioManager.stop()
            melodyAudioManager.stop()
            whiteNoiseAudioManager.stop()
        }
    }
}
