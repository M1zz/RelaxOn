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
struct CustomSound: Identifiable, Codable, Equatable, Playable {

    let id: UUID
    var title: String
    var category: SoundCategory
    var audioVariation: AudioVariation
    var filter: AudioFilter
    var color: String
    var backgroundSound: String? // 배경 사운드 ("파도", "비", "TV 소음") 저장
    var backgroundVolume: Float? // 배경 볼륨 저장

    init(
        title: String = "저장된 음원이 없습니다.",
        category: SoundCategory = .none,
        variation: AudioVariation = AudioVariation(),
        filter: AudioFilter = .none,
        color: String = "",
        backgroundSound: String? = nil,
        backgroundVolume: Float? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.audioVariation = variation
        self.filter = filter
        self.color = (color == "") ? category.defaultColor : color
        self.backgroundSound = backgroundSound
        self.backgroundVolume = backgroundVolume
    }
    
    static func == (lhs: CustomSound, rhs: CustomSound) -> Bool {
        return lhs.id == rhs.id
    }
}

/// 오디오 필터 관리를 위한 열거형
enum AudioFilter: String, Codable {
    case none
    case WaterDrop, Basement, Cave, Pipe, Sink
    case SingingBowl, Focus, Training, Empty, Vibration
    case Bird, Owl, Woodpecker, Forest, Cuckoo
    
    var duration: TimeInterval {
        switch self {
        case .none:
            return 0.0
            
        case .WaterDrop:
            return 1.0
        case .Basement:
            return 2.0
        case .Cave:
            return 2.0
        case .Pipe:
            return 3.0
        case .Sink:
            return 2.0
            
        case .SingingBowl:
            return 5.0
        case .Focus:
            return 5.0
        case .Training:
            return 4.0
        case .Empty:
            return 5.0
        case .Vibration:
            return 7.0
            
        case .Bird:
            return 1.0
        case .Owl:
            return 3.0
        case .Woodpecker:
            return 4.0
        case .Forest:
            return 4.0
        case .Cuckoo:
            return 3.0
        }
    }
}

/// 원본 사운드 유형 관리를 위한 열거형
enum SoundCategory: String, Codable {
    case none
    case WaterDrop, SingingBowl, Bird
    
    var displayName: String {
        switch self {
        case .none:
            return "없음"
        case .WaterDrop:
            return "물방울"
        case .SingingBowl:
            return "싱잉볼"
        case .Bird:
            return "새소리"
        }
    }
    
    var fileName: String {
        switch self {
        case .none:
            return "없음"
        case .WaterDrop:
            return "WaterDrop"
        case .SingingBowl:
            return "SingingBowl"
        case .Bird:
            return "Bird"
        }
    }
    
    var imageName: String {
        switch self {
        case .none:
            return "없음"
        case .WaterDrop:
            return "WaterDrop"
        case .SingingBowl:
            return "SingingBowl"
        case .Bird:
            return "Bird"
        }
    }
    
    var defaultColor: String {
        switch self {
        case .none:
            return "없음"
        case .WaterDrop:
            return "DCE8F5"
        case .SingingBowl:
            return "FDD0A8"
        case .Bird:
            return "ACD6A6"
        }
    }
}
