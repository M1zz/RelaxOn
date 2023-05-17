//
//  Enums.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/17.
//

/// Enum으로 관리되는 모든 것

import Foundation

enum TabItems: String {
    case create = "Create"
    case listen = "Listen"
    case relax = "Relax"
}

enum StarTabBarIcon: String {
    case starFill = "star.fill"
}

enum TabBarIcon: String {
    case homeTabIcon = "home_tab_icon"
    case listenTabIcon = "listen_tab_icon"
    case timerTabIcon = "timer_tab_icon"
}
