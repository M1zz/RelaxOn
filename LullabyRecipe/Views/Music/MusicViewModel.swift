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
    
    func fetchData(data: MixedSound) {
        mixedSound = data
    }
    
    func play() {
        if isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            naturalAudioManager.playPause()
        } else {
            baseAudioManager.startPlayer(track: mixedSound?.sounds[0].name ?? "chinese_gong", volume: 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.sounds[1].name ?? "chinese_gong")
            naturalAudioManager.startPlayer(track: mixedSound?.sounds[2].name ?? "chinese_gong", volume: 0.5)
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
