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
                TabView(selection: $appState.selectedTab) {
                    ForEach(appState.tabItems, id: \.id) { item in
                        item.view
                            .tabItem {
                                Image(item.imageName.rawValue)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text(item.title.rawValue)
                            }.tag(item.id)
                    }
                }
                .accentColor(Color(.PrimaryPurple))
                .environmentObject(appState)
            }

            if isFirstVisit && appState.showSoundDetail {
                SoundListView()
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
