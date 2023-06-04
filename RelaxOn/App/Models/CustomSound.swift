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
    
    init() {
        self.id = UUID()
        self.title = "저장된 음원이 없습니다."
        self.category = .none
        self.audioVariation = AudioVariation()
        self.filter = .none
        self.color = SoundCategory.none.defaultColor
    }
    
    init(title: String, category: SoundCategory, variation: AudioVariation, filter: AudioFilter, color: String = "") {
        self.id = UUID()
        self.title = title
        self.category = category
        self.audioVariation = variation
        self.filter = filter
        self.color = (color == "") ? category.defaultColor : color
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
}

/// 원본 사운드 유형 관리를 위한 열거형
enum SoundCategory: String, Codable {
    case none
    case waterDrop, singingBowl, bird
    
    var displayName: String {
        switch self {
        case .none:
            return "없음"
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
        case .none:
            return "없음"
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
        case .none:
            return "없음"
        case .waterDrop:
            return "WaterDrop"
        case .singingBowl:
            return "SingingBowl"
        case .bird:
            return "Bird"
        }
    }
    
    var defaultColor: String {
        switch self {
        case .none:
            return "없음"
        case .waterDrop:
            return "DCE8F5"
        case .singingBowl:
            return "FDD0A8"
        case .bird:
            return "ACD6A6"
        }
    }
}
