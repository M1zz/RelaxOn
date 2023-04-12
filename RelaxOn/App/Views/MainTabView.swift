//
//  MainTabView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var appState = AppState()
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            SoundListView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Create")
                }.tag(0)
            ListenListView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Listen")
                }.tag(1)
            RelaxView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Relax")
                }.tag(2)
        }
        .environmentObject(appState)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
