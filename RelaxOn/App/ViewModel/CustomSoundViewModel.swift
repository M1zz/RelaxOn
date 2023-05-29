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

    @Published var customSounds: [CustomSound] = []
    @Published var selectedSound: CustomSound? = nil
    @Published var searchText = ""
    @Published var isPlaying = false

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
            selectedSound?.audioFilter = filter
        }
    }
    
    var playPauseStatusImage: String {
        isPlaying ? PlayerButton.pause.rawValue : PlayerButton.play.rawValue
    }
    
    var filteredSounds: [CustomSound] {
        if searchText.isEmpty {
            return customSounds
        } else {
            return customSounds.filter { $0.fileName.contains(searchText) }
        }
    }
    
    init(customSound: CustomSound? = nil, filter: AudioFilter = .waterDrop) {
        self.selectedSound = customSound
        self.filter = filter
        
        pitch = Float.random(in: -5.0...5.0) // 0부터 1씩 증가하거나 감소
        speed = Float.random(in: 0.2...1.0)
        volume = Float.random(in: 0.2...1.0)
    }
    
}

// MARK: - Methods for View
extension CustomSoundViewModel {

    func playSound(originSound: OriginalSound) {
        audioEngineManager.play(with: originSound)
    }
    
    func playSound(customSound: CustomSound) {
        audioEngineManager.play(with: customSound)
    }
    
    func stopSound() {
        audioEngineManager.stop()
    }
    
    func loadSound() {
        customSounds = userDefaults.customSounds
    }
    
    func testForUpdateLoopSpeed() {
        audioEngineManager.loopSpeed = 2.0
    }

}

// MARK: - Methods for Model
extension CustomSoundViewModel {
    
    func save(with originalSound: OriginalSound, audioVariation: AudioVariation, fileName: String, color: Color) {
        var customSounds = userDefaults.customSounds
        if customSounds.contains(where: { $0.fileName == fileName }) {
            print("이미 이 파일이 존재합니다. 다른 로직을 수행할 수 없습니다.")
            // 유저에게 알리는 로직 추가
            return
        }
        
        let customSound = CustomSound(fileName: fileName, category: originalSound.category, audioVariation: audioVariation, audioFilter: originalSound.filter)
        fileManager.save(originalSound, audioVariation, fileName, color, audioEngineManager)
        
        customSounds.append(customSound)
        userDefaults.customSounds = customSounds
        loadSound()
    }
    
    func remove(at index: Int) {
        var customSounds = userDefaults.customSounds
        customSounds.remove(at: index)
        userDefaults.customSounds = customSounds
        loadSound()
    }
    
}

// MARK: - Image
extension CustomSoundViewModel {
    func loadImage(_ fileName: String) -> UIImage {
        return fileManager.loadImage(fileName: fileName)
    }
}

// MARK: - for UI Test
extension CustomSoundViewModel {
    func setTimerMainViewSelectedSound(_ selectedSound: CustomSound) {
        self.selectedSound = selectedSound
    }
}
