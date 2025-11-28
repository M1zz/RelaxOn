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
                ListenListView()
                    .environmentObject(appState)
            }

            if isFirstVisit && appState.showSoundDetail {
                ListenListView()
            }

            if isFirstVisit && !appState.showSoundDetail {
                OnboardingView(isFirstVisit: $isFirstVisit)
            }
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(isFirstVisit: true)
    }
}
