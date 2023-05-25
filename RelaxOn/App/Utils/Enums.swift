//
//  Enums.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/17.
//

/**
 Enum으로 관리되는 모든 것
 */

import Foundation

/// 탭 바 아이템
enum TabItems: String {
    case home = "홈"
    case listen = "듣기"
    case timer = "타이머"
}

// TODO: TabBarIcon으로 대체 후 삭제해야함
/// Sprint 4까지 사용하던 탭 바 아이콘
enum StarTabBarIcon: String {
    case starFill = "star.fill"
}

// TODO: 아직 어떤 이름으로 추가될 지 모르겠으나 되도록 오른쪽 String에 맞춰서 저장하면 좋을 것 같습니다.
/// 탭 바 아이콘 파일 이름
enum TabBarIcon: String {
    case homeTabIcon = "home_tab_icon"
    case listenTabIcon = "listen_tab_icon"
    case timerTabIcon = "timer_tab_icon"
}

/// 음악 파일 확장자를 하드코딩하지 않기 위해 생성한 객체
enum MusicExtension: String {
    case mp3
    case wav
}

/// 오디오 필터 관리를 위한 열거형
enum AudioFilter: String, Codable {
    case waterDrop, basement, cave, pipe, sink
    case singingBowl, focus, training, emptiness, vibration
    case bird, owl, woodpecker, forest
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
}
