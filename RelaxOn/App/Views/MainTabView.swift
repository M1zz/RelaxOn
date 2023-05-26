//
//  MainTabView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
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
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
