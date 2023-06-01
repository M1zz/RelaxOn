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

/// 탭 바 아이콘 파일 이름
enum TabBarIcon: String {
    case home = "home"
    case listen = "headphones"
    case timer = "alarm"
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
        case equalizerbutton = "Equalizer"
        case headphone = "Headphone"
        case lamp = "Lamp"
        case musicplayer = "MusicPlayer"
    }
    // 설명 문구
    enum IconText: String {
        case equlizerbutton = "나만의 소리를 찾기 위해\n소리를 커스텀해보세요."
        case headphone = "지금 바로 나만의 소리를 만들어 보세요!"
        case lamp = "수면에 도움되는 소리를 검색하고\n하나하나 들어보느라 오래 걸린 적 있나요?"
        case musicplayer = "사운드를 선택하고 원하는 시간만큼\n타이머를 설정한 후 숙면을 취해보세요."
    }
    // 튜토리얼 관련
    enum Tutorial: String {
        case image = "TutorialGesture"
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
