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
