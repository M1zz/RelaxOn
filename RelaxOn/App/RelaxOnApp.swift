//
//  RelaxOnApp.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI

@main
struct RelaxOnApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    @StateObject private var appState = AppState()
    @StateObject private var viewModel = CustomSoundViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(appState)
                .environmentObject(viewModel)
        }
    }
}
