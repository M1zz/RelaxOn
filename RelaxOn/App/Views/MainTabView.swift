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
        // 손쉬운 사용(큰 글씨)을 폭넓게 지원하되, 일부 비스크롤 화면 보호를 위해 상한을 둔다.
        // (홈 등 주요 화면은 자체적으로 스크롤 처리되어 어떤 크기에서도 깨지지 않는다.)
        .dynamicTypeSize(...DynamicTypeSize.accessibility3)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState())
    }
}
