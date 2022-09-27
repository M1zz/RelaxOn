//
//  PageView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/30.
//

import SwiftUI

struct PageView: View {
    @ObservedObject var watchConnectivityManager = WatchConnectivityManager.shared
    @State var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                CDListView(tabSelection: $tabSelection)
            }
            .tag(0)
            CDPlayerView(watchConnectivityManager: watchConnectivityManager)
            .tag(1)
        }
        .animation(Animation.easeInOut, value: tabSelection)
        .transition(.slide)
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView()
    }
}
