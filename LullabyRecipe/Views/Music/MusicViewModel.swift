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
        mixedSound = mixedSound
    }
    
    func play() {
        if isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            naturalAudioManager.playPause()
        } else {
            baseAudioManager.startPlayer(track: BaseAudioName.chineseGong.fileName, volume: 0.8)
            melodyAudioManager.startPlayer(track: MelodyAudioName.lynx.fileName)
            naturalAudioManager.startPlayer(track: NaturalAudioName.creekBabbling.fileName, volume: 0.5)
        }
        
    }
}
