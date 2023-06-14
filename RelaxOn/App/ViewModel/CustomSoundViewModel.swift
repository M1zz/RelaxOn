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
    /// 필터가 변경되었을 때 호출될 클로저
    var isFilterChanged: (() -> Void)?
    
    private var audioEngineManager = AudioEngineManager.shared
    private var fileManager = UserFileManager.shared
    private var userDefaults = UserDefaultsManager.shared
    
    /// 각 CustomSound 객체에 대응하는 인덱스를 저장하는 사전
    private(set) var customSoundsDictionary: [Int: CustomSound] = [:]
    
    let intervalRange: [Float] = stride(from: 0.5, through: 5.0, by: 0.1).map { Float($0) }
    let pitchRange: [Float] = stride(from: -50.0, through: 50.0, by: 10.0).map { Float($0) }
    let volumeRange: [Float] = stride(from: 0.0, through: 1.0, by: 0.01).map { Float($0) }
    
    // TODO: 필요없음. 없으면 안되는건지 재확인 후 삭제
    let filterRange: [Float] = stride(from: -50.0, through: 50.0, by: 1.0).map { Float($0) }
    
    /// 각 오디오 필터에 대한 서브 필터를 저장하는 딕셔너리
    let filterDictionary: [AudioFilter: [AudioFilter]] = [
        .WaterDrop: [.WaterDrop, .Basement, .Cave, .Pipe, .Sink],
        .SingingBowl: [.SingingBowl, .Focus, .Training, .Vibration],
        .Bird: [.Bird, .Owl, .Woodpecker, .Forest, .Cuckoo],
    ]
  
    /// 현재 재생되는 소리
    /// - 기본값 : OriginalSound(name: "물방울", filter: .WaterDrop, category: .waterDrop)
    @Published var sound: Playable = OriginalSound(name: "물방울", filter: .WaterDrop, category: .waterDrop)
    
    @Published var color = ""
    @Published var searchText = ""
    @Published var isPlaying = false
    
    /// 현재 선택된 소리의 인덱스
    @Published var currentSoundIndex: Int = 0
    
    /// 가장 마지막에 재생된 Sound 정보
    @Published var lastSound: CustomSound {
        didSet {
            userDefaults.lastPlayedSound = lastSound
        }
    }
    
    /// 현재 선택된 음원 저장
    @Published var selectedSound: CustomSound? = nil {
        didSet {
            if let selected = selectedSound, let index = customSoundsDictionary.first(where: { $0.value == selected })?.key {
                // 선택된 음원의 인덱스를 저장
                currentSoundIndex = index
            }
        }
    }
    
    /// UserDefaults에 저장된 커스텀 음원 배열
    @Published var customSounds: [CustomSound] = [] {
        didSet {
            UserDefaultsManager.shared.customSounds = customSounds // 변경된 커스텀 음원 배열을 UserDefaults에 저장
            customSoundsDictionary = Dictionary(uniqueKeysWithValues: zip(customSounds.indices, customSounds)) // 커스텀 음원 배열을 딕셔너리로 변환하여 저장 [배열 인덱스: 배열의 요소]
        }
    }
    
    /// sound의 재생 간격 저장
    @Published var interval = Float() {
        didSet {
            audioEngineManager.audioVariation.interval = interval
        }
    }
    
    /// sound의 피치 저장
    @Published var pitch = Float() {
        didSet {
            audioEngineManager.audioVariation.pitch = pitch
        }
    }
    
    /// sound의 볼륨 저장
    @Published var volume = Float() {
        didSet {
            audioEngineManager.audioVariation.volume = volume
        }
    }
    
    /// sound의 filter 저장
    @Published var filter: AudioFilter {
        didSet {
            selectedSound?.filter = filter
            isFilterChanged?()
        }
    }
    
    /// 현재 재생 상태에 따른 버튼 이미지 Asset 이름
    var playPauseStatusImage: String {
        isPlaying ? PlayerButton.pause.rawValue : PlayerButton.play.rawValue
    }
    
    /// 검색 텍스트에 따라 필터링된 음원 배열
    var filteredSounds: [CustomSound] {
        if searchText.isEmpty {
            return customSounds
        } else {
            return customSounds.filter { $0.title.contains(searchText) }
        }
    }
    
    /// 클래스 초기화 시 선택된 음원과 필터를 설정하고 재생된 음원을 불러옴
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

extension CustomSoundViewModel {
    
    func setSelectedSound(_ selectedSound: CustomSound) {
        self.selectedSound = selectedSound
        self.sound = selectedSound
    }
    
}
