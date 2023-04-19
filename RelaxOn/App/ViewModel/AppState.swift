//
//  AppState.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/04/18.
//

import SwiftUI

enum TabItems: String {
    case create = "Create"
    case listen = "Listen"
    case relax = "Relax"
}

enum StarTabBarIcon: String {
    case starFill = "star.fill"
}

struct TabItemInfo: Identifiable {
    let id = UUID()
    let view: AnyView
    let imageName: StarTabBarIcon
    let title: TabItems
}

/// 전역적인 상태를 관리하는 ViewModel
/// SoundSaveView 에서 Modal을 dismiss 한 후 Listen 탭으로 이동하기 위해 필요
final class AppState: ObservableObject {
    @Published var selectedTab: UUID = UUID()
    
    let tabItems = [
        TabItemInfo(view: AnyView(SoundListView()), imageName: .starFill, title: .create),
        TabItemInfo(view: AnyView(ListenListView()), imageName: .starFill, title: .listen),
        TabItemInfo(view: AnyView(RelaxView()), imageName: .starFill, title: .relax)
    ]
    
    func moveToTab(_ tab: TabItems) {
        if let tabItem = tabItems.first(where: { $0.title == tab }) {
            selectedTab = tabItem.id
        }
    }
}