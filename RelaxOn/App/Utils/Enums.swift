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

enum MusicExtension: String {
    case mp3
}

// CircularSlider에 쓰이는 Icon
enum FeatureIcon: String {
    case filter = "filter"
    case volume = "volume"
    case fitch = "fitch"
    case interval = "interval"
    // SoundDetailView에서만 쓰이는 이미지
    case headset = "headset"
  
  // 온보딩 관련
enum OnboardInfo {
    // 아이콘 파일이름
    enum IconName: String {
        case equalizerbutton = "equalizerbutton"
        case headphone = "headphone"
        case lamp = "lamp"
        case musicplayer = "musicplayer"
    }
    // 설명 문구
    enum IconText: String {
        case equlizerbutton = "나만의 소리를 찾기 위해 소리를 커스텀해보세요."
        case headphone = "지금 바로 나만의 소리를 만들어 보세요!"
        case lamp = "수면에 도움되는 소리를 검색하고 하나하나 들어보느라 오래 걸린 적 있나요?"
        case musicplayer = "사운드를 선택하고 원하는 시간만큼 타이머를 설정한 후 숙면을 취해보세요."
    }
    // 튜토리얼 관련
    enum Tutorial: String {
        case tutorialImage = "tutorialGesture"
    }
}
