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
    @Published var naturalAudioManager = AudioManager()
    @Published var isPlaying: Bool = false
    
    @Published var mixedSound: MixedSound?
    
    func updateVolume(audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float)) {
        self.mixedSound?.baseSound?.audioVolume = audioVolumes.baseVolume
        self.mixedSound?.melodySound?.audioVolume = audioVolumes.melodyVolume
        self.mixedSound?.naturalSound?.audioVolume = audioVolumes.naturalVolume
    }
    
    func fetchData(data: MixedSound) {
        mixedSound = data
    }
    
    func play() {
        if isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            naturalAudioManager.playPause()
        } else {
            baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "chinese_gong", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "chinese_gong", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
            naturalAudioManager.startPlayer(track: mixedSound?.naturalSound?.name ?? "chinese_gong", volume: mixedSound?.naturalSound?.audioVolume ?? 0.8)
        }
    }
    
    func stop() {
        if isPlaying {
            baseAudioManager.stop()
            melodyAudioManager.stop()
            naturalAudioManager.stop()
        }
    }
}
