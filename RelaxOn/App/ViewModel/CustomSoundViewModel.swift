//
//  CustomSoundViewModel.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/25.
//

import AVFoundation
import SwiftUI

/**
 View와 직접적으로 사운드 데이터 바인딩하는 ViewModel 객체
 */
final class CustomSoundViewModel: ObservableObject {
    
    // MARK: - Properties
    var isFilterChanged: (() -> Void)?
    
    private var audioEngineManager = AudioEngineManager.shared
    private var fileManager = UserFileManager.shared
    private var userDefaults = UserDefaultsManager.shared
    private(set) var customSoundsDictionary: [Int: CustomSound] = [:]

    let intervalRange: [Float] = stride(from: -2.0, through: 2.0, by: 1.0).map { Float($0) }
    let pitchRange: [Float] = stride(from: -50.0, through: 50.0, by: 1.0).map { Float($0) }
    let volumeRange: [Float] = stride(from: -2.0, through: 2.0, by: 1.0).map { Float($0) }
    let filterRange: [Float] = stride(from: -50.0, through: 50.0, by: 1.0).map { Float($0) }
    
    let filterDictionary: [AudioFilter: [AudioFilter]] = [
        .WaterDrop: [.WaterDrop, .Basement, .Cave, .Pipe, .Sink],
        .SingingBowl: [.SingingBowl, .Focus, .Training, .Vibration],
        .Bird: [.Bird, .Owl, .Woodpecker, .Forest, .Cuckoo],
    ]

    @Published var sound: Playable = OriginalSound(name: "물방울", filter: .WaterDrop, category: .waterDrop)
    @Published var color = ""
    @Published var searchText = ""
    @Published var isPlaying = false
    @Published var currentSoundIndex: Int = 0
    
    @Published var lastSound: CustomSound {
        didSet {
            userDefaults.lastPlayedSound = lastSound
        }
    }
    
    @Published var selectedSound: CustomSound? = nil {
        didSet {
            if let selected = selectedSound, let index = customSoundsDictionary.first(where: { $0.value == selected })?.key {
                currentSoundIndex = index
            }
        }
    }
    
    @Published var customSounds: [CustomSound] = [] {
        didSet {
            UserDefaultsManager.shared.customSounds = customSounds
            customSoundsDictionary = Dictionary(uniqueKeysWithValues: zip(customSounds.indices, customSounds))
        }
    }
    
    @Published var interval = Float() {
        didSet {
            audioEngineManager.audioVariation.interval = interval
        }
    }
    
    @Published var pitch = Float() {
        didSet {
            audioEngineManager.audioVariation.pitch = pitch
        }
    }
    
    @Published var volume = Float() {
        didSet {
            audioEngineManager.audioVariation.volume = volume
        }
    }
    
    @Published var filter: AudioFilter {
        didSet {
            selectedSound?.filter = filter
            isFilterChanged?()
        }
    }
    
    var playPauseStatusImage: String {
        isPlaying ? PlayerButton.pause.rawValue : PlayerButton.play.rawValue
    }
    
    var filteredSounds: [CustomSound] {
        if searchText.isEmpty {
            return customSounds
        } else {
            return customSounds.filter { $0.title.contains(searchText) }
        }
    }

    init(customSound: CustomSound? = nil, filter: AudioFilter = .none) {
        self.selectedSound = customSound
        self.filter = filter
        self.lastSound = userDefaults.lastPlayedSound
    }
}

// MARK: - Methods for View
extension CustomSoundViewModel {
    
    func play<T: Playable>(with sound: T) {
        isPlaying.toggle()
        audioEngineManager.play(with: sound)
    }
    
    func stopSound() {
        isPlaying.toggle()
        audioEngineManager.stop()
    }
    
    func loadSound() {
        customSounds = userDefaults.customSounds
    }
    
    func playPreviousSound() {
        if currentSoundIndex > 0 {
            currentSoundIndex -= 1
            if let previousSound = customSoundsDictionary[currentSoundIndex] {
                selectedSound = previousSound
                play(with: previousSound)
            }
        }
    }
    
    func playNextSound() {
        if currentSoundIndex < customSounds.count - 1 {
            currentSoundIndex += 1
            if let nextSound = customSoundsDictionary[currentSoundIndex] {
                selectedSound = nextSound
                play(with: nextSound)
            }
        }
    }
}

// MARK: - Methods for Model
extension CustomSoundViewModel {
    
    func save(with sound: OriginalSound, filter: AudioFilter, title: String, color: String) -> Bool {
        var customSounds = userDefaults.customSounds
        if customSounds.contains(where: { $0.title == title }) {
            print("이미 이 파일이 존재합니다. 다른 로직을 수행할 수 없습니다.")
            return false
        }
        
        let variation = AudioVariation(volume: volume, pitch: pitch, interval: interval)
        let customSound = CustomSound(title: title, category: sound.category, variation: variation, filter: filter, color: color)
        if !fileManager.saveCustomSound(customSound) {
            return false
        }
        
        customSounds.append(customSound)
        userDefaults.customSounds = customSounds
        loadSound()
        
        return true
    }

    func remove(at index: Int) {
        var customSounds = userDefaults.customSounds
        customSounds.remove(at: index)
        userDefaults.customSounds = customSounds
        loadSound()
    }
    
}

// MARK: - for UI
extension CustomSoundViewModel {
    
    func setTimerMainViewSelectedSound(_ selectedSound: CustomSound) {
        self.selectedSound = selectedSound
    }
    
}
