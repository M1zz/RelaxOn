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
    private var audioEngineManager = AudioEngineManager()
    private var fileManager = UserFileManager.shared
    private var userDefaults = UserDefaultsManager.shared

    @Published var customSounds = [Int: String]()
    
    @Published var nowPlayingCustomSound: CustomSound?
    
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
            nowPlayingCustomSound?.audioFilter = filter
        }
    }
    
    var playPauseStatusImage: String {
        isPlaying ? PlayPauseButton.pause.rawValue : PlayPauseButton.play.rawValue
    }
    
    init(customSound: CustomSound? = nil, filter: AudioFilter = .waterDrop) {
        self.nowPlayingCustomSound = customSound
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
        customSounds = userDefaults.customSoundsDic
    }
    
    func testForUpdateLoopSpeed() {
        audioEngineManager.loopSpeed = 2.0
    }

}

// MARK: - Methods for Model
extension CustomSoundViewModel {
    
    func save(with originalSound: OriginalSound, audioVariation: AudioVariation, fileName: String, color: Color) {
        let customSoundDic = userDefaults.customSoundsDic
        if customSoundDic.values.contains(fileName) {
            print("이미 이 파일이 존재합니다 다른 로직을 수행할 수 없습니다. 라고 유저에게 알리기")
            return
        }
        
        fileManager.save(originalSound, audioVariation, fileName, color, audioEngineManager)
        
        /// UserDefaults에 [인덱스: 파일명] 업데이트
        let index = customSoundDic.count
        userDefaults.customSoundsDic[index] = fileName
        loadSound()
    }
    
    func remove(at index: Int) {
        customSounds.removeValue(forKey: index)
        loadSound()
    }
    
}

// MARK: - Image
extension CustomSoundViewModel {
    func loadImage(_ fileName: String) -> UIImage {
        return fileManager.loadImage(fileName: fileName)
    }
}
