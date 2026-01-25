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
    case listen = "듣기"
}

/// 탭 바 아이콘 파일 이름
enum TabBarIcon: String {
    case listen = "headphones"
}

/// 음악 파일 확장자를 하드코딩하지 않기 위해 생성한 객체
enum MusicExtension: String {
    case mp3
    case wav
}

/// 파일 확장자를 하드코딩하지 않기 위해 생성한 객체
enum FileExtension: String {
    case json
    case png
    case jpg
    case jpeg
}

enum PlayerButton: String {
    case play = "play"
    case pause = "pause"
    case fastForward = "fast_forward"
    case fastRewind = "fast_rewind"
}

// CircularSlider에 쓰이는 Icon
enum FeatureIcon: String {
    case filter = "filter"
    case volume = "volume"
    case pitch = "pitch"
    case interval = "interval"
    // SoundDetailView에서만 쓰이는 이미지
    case headset = "headset"
}

  // 온보딩 관련
enum OnboardInfo {
    // 아이콘 파일이름
    enum IconName: String {
        case Equalizer = "Equalizer"
        case Headphone = "Headphone"
        case Lamp = "Lamp"
        case Musicplayer = "Musicplayer"
    }
    // 설명 문구
    enum IconText: String {
        case Equlizer = "여러 개의 소리를 레이어처럼 겹쳐서\n나만의 완벽한 사운드를 만들어보세요"
        case Headphone = "캠프파이어 곁에서 편안한 사운드와 함께\n휴식을 즐겨보세요"
        case Lamp = "물방울, 새소리, 싱잉볼...\n자연의 소리로 마음의 평화를 찾아보세요"
        case Musicplayer = "배경 음악을 더해 더욱 풍부한 사운드를\n경험하고, 타이머로 수면을 관리하세요"
    }
}

enum SelectSound: String {
    case checked_circle
    case unchecked_circle
}

enum TimerButton: String {
    case reset_activated
    case reset_deactivated
    case start_circle
    case pause_circle
    case resume_circle
}
