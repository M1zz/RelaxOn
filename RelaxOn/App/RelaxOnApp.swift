//
//  RelaxOnApp.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI

/// 전역적인 상태를 관리하는 ViewModel
/// SoundSaveView 에서 Modal을 dismiss 한 후 Listen 탭으로 이동하기 위해 필요
class AppState: ObservableObject {
    @Published var selectedTab: Int = 0
}

@main
struct RelaxOnApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
        }
    }
}
