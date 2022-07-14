//
//  ContentView.swift
//  WatchLullabyRecipe WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/07/10.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        
        VStack {
            TabView(selection: $selection) {
                
                ListView(selection: $selection)
                    .tag(0)
                PlayerView()
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
            .animation(.easeInOut)
            .transition(.slide)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
