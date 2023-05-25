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
    case home = "home"
    case listen = "headphones"
    case timer = "alarm"
}

enum MusicExtension: String {
    case mp3
}
