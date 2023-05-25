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
    
    @Published var nowPlayingCustomSound: CustomSound?

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
    
    func stopSound() {
        audioEngineManager.stop()
    }

}

// MARK: - Methods for Model
extension CustomSoundViewModel {
    
    func save(with originalSound: OriginalSound, audioVariation: AudioVariation, fileName: String, color: Color) {
        
        /// 이미 저장된 파일명인지 확인
        let customSoundDic = userDefaults.customSoundsDic
        
        if customSoundDic.values.contains(fileName) {
            print("이미 이 파일이 존재합니다 다른 로직을 수행할 수 없습니다. 라고 유저에게 알리기")
            return
        }
        
        // TODO: FileManager에 커스텀 이미지 저장
        
        // TODO: FileManager에 커스텀 오디오파일 저장
        
        // TODO: FileManager에 커스텀 오디오 정보 JSON 저장
        
        /// UserDefaults에 [인덱스: 파일명] 업데이트
        let index = customSoundDic.count
        userDefaults.customSoundsDic[index] = fileName
    }
    
}
