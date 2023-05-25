//
//  MainTabView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var appState = AppState()
    @StateObject var customSoundViewModel = CustomSoundViewModel()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            ForEach(appState.tabItems) { item in
                item.view
                    .tabItem {
                        Image(systemName: item.imageName.rawValue)
                            .foregroundColor(.black)
                        Text(item.title.rawValue)
                    }.tag(item.id)
            }
        }
        .environmentObject(appState)
        .environmentObject(customSoundViewModel)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
