//
//  CustomSound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/10.
//

import Foundation

// TODO: CustomSound 객체로 교체 필요
/**
 사용자가 커스텀한 사운드 정보를 저장하고 불러오기 위한 구조체
 */
struct MixedSound: Identifiable, Codable {
    let id: UUID             // 생성된 MixedSound의 고유 아이디
    var name: String         // 생성된 MixedSound의 name
    var volume: Float        // 저장할 볼륨 값
    var imageName: String    // 저장할 이미지
    var audioFileURL: String // 저장된 오디오 파일의 URL
    
    init(name: String, volume: Float = 0.5, imageName: String = "placeholderImage", audioFileURL: String = "") {
        self.id = UUID()
        self.name = name
        self.volume = volume
        self.imageName = imageName
        self.audioFileURL = audioFileURL
    }
}

/**
 사용자가 커스텀한 사운드 정보를 저장하고 불러오기 위한 구조체
 */
struct CustomSound: Identifiable, Codable {
    let id: UUID
    var fileName: String
    var category: SoundCategory
    var audioVariation: AudioVariation
    var audioFilter: AudioFilter
    
    init(name: String, volume: Float = 0.5, pitch: Float = 0.0, speed: Float = 1.0, category: SoundCategory, filter: AudioFilter) {
        self.id = UUID()
        self.fileName = name
        self.category = category
        self.audioVariation = AudioVariation(volume: volume, pitch: pitch, speed: speed)
        self.audioFilter = filter
    }
}

/**
 원본 사운드 유형 관리를 위한 열거형
 */
enum SoundCategory: String, Codable {
    case waterDrop, singingBowl, bird
}

/**
 오디오 변형 관리를 위한 구조체
 */
struct AudioVariation: Codable {
    var volume: Float
    var pitch: Float
    var speed: Float
}

/**
 오디오 필터 관리를 위한 열거형
 */
enum AudioFilter: String, Codable {
    case waterDrop, basement, cave, pipe, sink
    case singingBowl, focus, training, emptiness, vibration
    case bird, owl, woodpecker, forest
}
