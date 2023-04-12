//
//  MainTabView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SoundListView()
            .tabItem {
                Image(systemName: "star.fill")
                Text("Create")
            }
            ListenListView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Listen")
                }
            RelaxView()
                .environmentObject(Time())
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Relax")
                }
        }
        
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
