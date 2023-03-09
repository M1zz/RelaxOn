//
//  RootView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct RootView: View {
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
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Relax")
                }
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
