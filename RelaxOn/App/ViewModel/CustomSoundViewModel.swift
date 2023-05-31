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
    private var audioEngineManager = AudioEngineManager.shared
    private var fileManager = UserFileManager.shared
    private var userDefaults = UserDefaultsManager.shared
    private(set) var customSoundsDictionary: [Int: CustomSound] = [:]

    let intervalRange: [Float] = stride(from: -2.0, through: 2.0, by: 1.0).map { Float($0) }
    let pitchRange: [Float] = stride(from: -50.0, through: 50.0, by: 1.0).map { Float($0) }
    let volumeRange: [Float] = stride(from: -2.0, through: 2.0, by: 1.0).map { Float($0) }
    let filterRange: [Float] = stride(from: -50.0, through: 50.0, by: 1.0).map { Float($0) }

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
    
    @Published var speed = Float() {
        didSet {
            audioEngineManager.updateAudioVariation(volume: volume, pitch: pitch, speed: speed)
        }
    }
    
    @Published var pitch = Float() {
        didSet {
            audioEngineManager.updateAudioVariation(volume: volume, pitch: pitch, speed: speed)
        }
    }
    
    @Published var volume = Float() {
        didSet {
            audioEngineManager.updateAudioVariation(volume: volume, pitch: pitch, speed: speed)
        }
    }
    
    @Published var filter: AudioFilter {
        didSet {
            selectedSound?.filter = filter
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
        print("[ init ] =============== CustomSoundViewModel ===============")
        self.selectedSound = customSound
        self.filter = filter
        self.lastSound = userDefaults.lastPlayedSound
        
        pitch = Float.random(in: -5.0...5.0)
        speed = Float.random(in: 0.2...1.0)
        volume = Float.random(in: 0.2...1.0)
    }
    
    deinit {
        print("[deinit] =============== CustomSoundViewModel ===============")
    }
    
}

// MARK: - Methods for View
extension CustomSoundViewModel {
    
    func playSound(originSound: OriginalSound) {
        audioEngineManager.updateAudioVariation(volume: volume, pitch: pitch, speed: 1.0)
        isPlaying.toggle()
        audioEngineManager.play(with: originSound)
    }
    
    func playSound(customSound: CustomSound) {
        guard let customSoundFromJSON = fileManager.loadCustomSound(title: customSound.title) else {
            print("해당 JSON 파일을 찾을 수 없습니다.")
            return
        }
        isPlaying.toggle()
        audioEngineManager.play(with: customSoundFromJSON)
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
                playSound(customSound: previousSound)
            }
        }
    }
    
    func playNextSound() {
        if currentSoundIndex < customSounds.count - 1 {
            currentSoundIndex += 1
            if let nextSound = customSoundsDictionary[currentSoundIndex] {
                selectedSound = nextSound
                playSound(customSound: nextSound)
            }
        }
    }
    
}

// MARK: - Methods for Model
extension CustomSoundViewModel {
    
    func save(with originalSound: OriginalSound, audioVariation: AudioVariation, fileName: String, color: String) -> Bool {
        var customSounds = userDefaults.customSounds
        if customSounds.contains(where: { $0.title == fileName }) {
            print("이미 이 파일이 존재합니다. 다른 로직을 수행할 수 없습니다.")
            return false
        }
        
        let customSound = makeCustomSound(fileName, originalSound, audioVariation, color)
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

// MARK: - make
extension CustomSoundViewModel {
    
    func makeCustomSound(_ title: String, _ sound: OriginalSound, _ variation: AudioVariation, _ color: String) -> CustomSound {
        return CustomSound(fileName: title, category: sound.category, audioVariation: variation, audioFilter: sound.filter, color: color)
    }
    
}
