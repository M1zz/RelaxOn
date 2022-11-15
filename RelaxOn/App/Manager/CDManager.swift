//
//  CDManager.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI
import AVFoundation

final class CDManager: ObservableObject {
    @Published var isPlaying: Bool = false
    @Published var CDList: [CD] = CD.CDTempList
    //UserDefaultsManager.shared.getCDList()
    @Published var playingCD: CD? {
        didSet {
            startPlayer(CD: playingCD)
        }
    }
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var whiteNoiseAudioManager = AudioManager()
    
    init(playingCD: CD? = nil) {
        self.playingCD = playingCD
    }
    
    func changeCD(CD: CD?) {
        print(CD)
        playingCD = CD
    }
    
    func startPlayer(CD: CD?) {
        baseAudioManager.startPlayer(track: CD?.base?.fileName ?? "base_default", volume: CD?.base?.audioVolume ?? 0.8)
        melodyAudioManager.startPlayer(track: CD?.melody?.fileName ?? "base_default", volume: CD?.melody?.audioVolume ?? 0.8)
        whiteNoiseAudioManager.startPlayer(track: CD?.whiteNoise?.fileName ?? "base_default", volume: CD?.whiteNoise?.audioVolume ?? 0.8)
        print(CD?.base?.audioVolume)
        print(CD?.melody?.audioVolume)
        print(CD?.whiteNoise?.audioVolume)
        isPlaying = true
    }
    
    func playPause() {
        print(#function)
        baseAudioManager.playPause()
        melodyAudioManager.playPause()
        whiteNoiseAudioManager.playPause()
        isPlaying.toggle()
    }
    
    func playTempCD() {
        print(#function)
    }
    
    func playPreCD() {
        if let playingCD = playingCD, let preCD = CDList.last(where: { $0.id < playingCD.id }) {
            print("preCD", preCD)
            changeCD(CD: preCD)
        } else {
            let lastCD = CDList.last
            print("lastCD", lastCD)
            changeCD(CD: lastCD)
        }
    }
    
    func playNextCD() {
        if let playingCD = playingCD, let nextCD = CDList.first(where: { $0.id > playingCD.id }) {
            print("nextCD", nextCD)
            changeCD(CD: nextCD)
        } else {
            let firstCD = CDList.first
            print("firstCD", firstCD)
            changeCD(CD: firstCD)
        }
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



