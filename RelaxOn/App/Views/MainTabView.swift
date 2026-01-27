//
//  MainTabView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var appState: AppState
    @State var isFirstVisit: Bool = UserDefaultsManager.shared.isFirstVisit

    var body: some View {
        ZStack {
            if !isFirstVisit {
                NavigationStack {
                    ListenListView()
                        .environmentObject(appState)
                }
            }

            if isFirstVisit && appState.showSoundDetail {
                NavigationStack {
                    ListenListView()
                }
            }

            if isFirstVisit && !appState.showSoundDetail {
                OnboardingView(isFirstVisit: $isFirstVisit)
            }
        }
        .onChange(of: isFirstVisit) { newValue in
            UserDefaultsManager.shared.isFirstVisit = newValue
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState())
    }
}
