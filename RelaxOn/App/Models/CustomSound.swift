//
//  CustomSound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/10.
//

import Foundation

/**
 사용자가 커스텀한 사운드 정보를 저장하고 불러오기 위한 구조체
 */
struct CustomSound: Identifiable, Codable, Equatable {
    
    let id: UUID
    var title: String
    var category: SoundCategory
    var audioVariation: AudioVariation
    var filter: AudioFilter
    var color: String
    
    init(fileName: String, category: SoundCategory, audioVariation: AudioVariation, audioFilter: AudioFilter, color: String = "") {
        self.id = UUID()
        self.title = fileName
        self.category = category
        self.audioVariation = audioVariation
        self.filter = audioFilter
        self.color = (color == "") ? category.defaultColor : color
    }
    
    static func == (lhs: CustomSound, rhs: CustomSound) -> Bool {
        return lhs.id == rhs.id
    }
}

// TODO: Enum 파일에 옮길거임
/// 오디오 필터 관리를 위한 열거형
enum AudioFilter: String, Codable {
    case WaterDrop, Basement, Cave, Pipe, Sink
    case SingingBowl, Focus, Training, Emptiness, Vibration
    case Bird, Owl, Woodpecker, Forest
}

/// 원본 사운드 유형 관리를 위한 열거형
enum SoundCategory: String, Codable {
    case waterDrop, singingBowl, bird
    
    var displayName: String {
        switch self {
        case .waterDrop:
            return "물방울"
        case .singingBowl:
            return "싱잉볼"
        case .bird:
            return "새소리"
        }
    }
    
    var fileName: String {
        switch self {
        case .waterDrop:
            return "WaterDrop"
        case .singingBowl:
            return "SingingBowl"
        case .bird:
            return "Bird"
        }
    }
    
    var imageName: String {
        switch self {
        case .waterDrop:
            return "WaterDrop"
        case .singingBowl:
            return "Wind" // TODO: 이미지 업데이트 후 변경 필요
        case .bird:
            return "Forest" // TODO: 이미지 업데이트 후 변경 필요
        }
    }
    
    var defaultColor: String {
        switch self {
        case .waterDrop:
            return "DCE8F5"
        case .singingBowl:
            return "DCE8F5" // TODO: 이미지 업데이트 후 변경 필요
        case .bird:
            return "DCE8F5" // TODO: 이미지 업데이트 후 변경 필요
        }
    }
}
