//
//  MusicViewModel.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI
import AVFoundation
import WidgetKit

final class MusicViewModel: NSObject, ObservableObject {
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var naturalAudioManager = AudioManager()
    @Published var isPlaying: Bool = false {
        didSet {
            #warning("userdefault")
            // play 될 때마다 timeline reset하기
            print("RelaxOnWidget !")
            
            let imageName = mixedSound?.imageName
            let name = mixedSound?.name
            let id = mixedSound?.id
            UserDefaults(suiteName: "group.widget.relaxOn")!.set(imageName, forKey: "imageName")
            UserDefaults(suiteName: "group.widget.relaxOn")!.set(name, forKey: "name")
            UserDefaults(suiteName: "group.widget.relaxOn")!.set(id, forKey: "id")
            
            WidgetCenter.shared.reloadTimelines(ofKind: "RelaxOnWidget")
//            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    
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
            // play 할 때 mixedSound 볼륨 적용 시도
            baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "base_default", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "base_default", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
            naturalAudioManager.startPlayer(track: mixedSound?.naturalSound?.name ?? "base_default", volume: mixedSound?.naturalSound?.audioVolume ?? 0.8)
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
