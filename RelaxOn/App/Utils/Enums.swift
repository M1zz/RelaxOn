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

enum MusicExtension: String {
    case mp3
}

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
}
