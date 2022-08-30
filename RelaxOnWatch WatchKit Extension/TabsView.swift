//
//  TabsView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/30.
//

import SwiftUI

struct TabsView: View {
    @State var tabNumber = 0
//    @StateObject var playerViewModel = PlayerViewModel()
    
    var body: some View {
        TabView(selection: $tabNumber) {
            NavigationView {
                ListView(tabNumber: $tabNumber)
            }.tag(0)
            PlayerView()
                .tag(1)
        }
        .animation(Animation.easeInOut, value: tabNumber)
        .transition(.slide)
    }
}

//struct TabsView_Previews: PreviewProvider {
//    static var previews: some View {
//        TabsView()
//    }
//}
