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
    
    let intervalRange: [Float] = stride(from: 0.1, through: 2.0, by: 0.1).map {
        Float(String(format: "%.2f", $0)) ?? 0.0
    }
    let pitchRange: [Float] = stride(from: -5.0, through: 5.0, by: 0.5).map {
        Float(String(format: "%.2f", $0)) ?? 0.0
    }
    let volumeRange: [Float] = stride(from: 0.1, through: 1.0, by: 0.01).map {
        Float(String(format: "%.2f", $0)) ?? 0.0
    }
    
    /// 각 오디오 필터에 대한 서브 필터를 저장하는 딕셔너리
    let filterDictionary: [SoundCategory: [AudioFilter]] = [
        .WaterDrop: [.WaterDrop, .Basement, .Cave, .Pipe, .Sink],
        .SingingBowl: [.SingingBowl, .Focus, .Training, .Empty, .Vibration],
        .Bird: [.Bird, .Owl, .Woodpecker, .Forest, .Cuckoo],
    ]
  
    /// 현재 재생되는 소리
    /// - 기본값 : OriginalSound(name: "물방울", filter: .WaterDrop, category: .waterDrop)
    @Published var sound: Playable = OriginalSound(name: "물방울", filter: .WaterDrop, category: .WaterDrop)
    
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
    @Published var interval: Float = 1.0 {
        didSet {
            audioEngineManager.audioVariation.interval = interval
        }
    }
    
    /// sound의 피치 저장
    @Published var pitch: Float = 0 {
        didSet {
            audioEngineManager.audioVariation.pitch = pitch
        }
    }
    
    /// sound의 볼륨 저장
    @Published var volume: Float = 1.0 {
        didSet {
            audioEngineManager.audioVariation.volume = volume
        }
    }
    
    /// sound의 filter 저장
    @Published var filter: AudioFilter {
        didSet {
            sound.filter = filter
            if isPlaying {
                stopSound()
                play(with: sound)
            }
        }
    }

    /// sound의 간격 변동폭 저장
    @Published var intervalVariation: Float = 0.0 {
        didSet {
            audioEngineManager.audioVariation.intervalVariation = intervalVariation
        }
    }

    /// sound의 볼륨 변동폭 저장
    @Published var volumeVariation: Float = 0.0 {
        didSet {
            audioEngineManager.audioVariation.volumeVariation = volumeVariation
        }
    }

    /// sound의 피치 변동폭 저장
    @Published var pitchVariation: Float = 0.0 {
        didSet {
            audioEngineManager.audioVariation.pitchVariation = pitchVariation
        }
    }

    @Published var filters: [AudioFilter] = []
    
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
    
    // MARK: - Initialization
    init(customSound: CustomSound? = nil, filter: AudioFilter = .none) {
        self.selectedSound = customSound
        self.filter = filter
        self.lastSound = userDefaults.lastPlayedSound
        self.filters = []
    }
    
}

// MARK: - Methods for View
extension CustomSoundViewModel {
    
    func play<T: Playable>(with sound: T) {
        if !isPlaying {
            isPlaying = true
        }
        audioEngineManager.play(with: sound)
    }
    
    func stopSound() {
        if isPlaying {
            isPlaying = false
        }
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

        let variation = AudioVariation(
            volume: volume,
            pitch: pitch,
            interval: interval,
            intervalVariation: intervalVariation,
            volumeVariation: volumeVariation,
            pitchVariation: pitchVariation
        )
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
        let removedSound = customSounds[index]
        // 파일도 함께 삭제
        fileManager.deleteCustomSound(title: removedSound.title)
        customSounds.remove(at: index)
        userDefaults.customSounds = customSounds
        loadSound()
    }

    func update(originalSound: CustomSound, newTitle: String, newColor: String) -> Bool {
        var customSounds = userDefaults.customSounds

        // 제목이 변경되었고, 새 제목이 이미 존재하는 경우
        if originalSound.title != newTitle && customSounds.contains(where: { $0.title == newTitle }) {
            print("이미 이 제목의 파일이 존재합니다.")
            return false
        }

        // ID로 기존 사운드 찾기
        guard let index = customSounds.firstIndex(where: { $0.id == originalSound.id }) else {
            print("수정할 사운드를 찾을 수 없습니다.")
            return false
        }

        // 업데이트된 CustomSound 생성 (기존 ID 유지)
        var updatedSound = customSounds[index]
        let oldTitle = updatedSound.title
        updatedSound.title = newTitle
        updatedSound.color = newColor
        updatedSound.audioVariation = AudioVariation(
            volume: volume,
            pitch: pitch,
            interval: interval,
            intervalVariation: intervalVariation,
            volumeVariation: volumeVariation,
            pitchVariation: pitchVariation
        )
        updatedSound.filter = filter

        // 파일 업데이트
        if !fileManager.updateCustomSound(updatedSound, oldTitle: oldTitle) {
            return false
        }

        // UserDefaults 업데이트
        customSounds[index] = updatedSound
        userDefaults.customSounds = customSounds
        loadSound()

        return true
    }

    /// 샘플 데이터 생성 (테스트용)
    func createSampleData() {
        let sampleSounds: [(String, SoundCategory, AudioFilter, AudioVariation, String)] = [
            ("아침 명상", .Bird, .Forest, AudioVariation(volume: 0.5, pitch: -1.0, interval: 1.8), "C8E6C9"),
            ("집중 타임", .WaterDrop, .WaterDrop, AudioVariation(volume: 0.7, pitch: 0.5, interval: 0.8), "D0E3F0"),
            ("숙면 도우미", .SingingBowl, .Empty, AudioVariation(volume: 0.4, pitch: -1.5, interval: 2.0), "F5C89B"),
            ("빗소리 감성", .WaterDrop, .Sink, AudioVariation(volume: 0.8, pitch: -1.5, interval: 0.6), "A8C8E0"),
            ("차분한 밤", .Bird, .Owl, AudioVariation(volume: 0.6, pitch: -0.5, interval: 1.5), "9EC49A"),
            ("동굴의 물소리", .WaterDrop, .Cave, AudioVariation(volume: 0.6, pitch: -2.0, interval: 1.5), "B8D4E8"),
            ("명상 벨", .SingingBowl, .SingingBowl, AudioVariation(volume: 0.5, pitch: 0.0, interval: 1.2), "FFD4A3"),
            ("새벽 새소리", .Bird, .Cuckoo, AudioVariation(volume: 0.5, pitch: -0.5, interval: 1.5), "ACD6A6"),
            ("휴식의 시간", .SingingBowl, .Focus, AudioVariation(volume: 0.6, pitch: -0.5, interval: 1.8), "FDD0A8"),
            ("자연의 소리", .Bird, .Woodpecker, AudioVariation(volume: 0.7, pitch: 0.0, interval: 1.0), "B5D8A7")
        ]

        var customSounds = userDefaults.customSounds

        for (title, category, filter, variation, color) in sampleSounds {
            // 중복 체크
            if customSounds.contains(where: { $0.title == title }) {
                continue
            }

            let customSound = CustomSound(
                title: title,
                category: category,
                variation: variation,
                filter: filter,
                color: color
            )

            // 파일 저장
            if fileManager.saveCustomSound(customSound) {
                customSounds.append(customSound)
            }
        }

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
