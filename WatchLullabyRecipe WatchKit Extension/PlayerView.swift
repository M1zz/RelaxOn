//
//  PlayerView.swift
//  WatchLullabyRecipe WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/07/13.
//

import SwiftUI

struct PlayerView: View {
    var body: some View {
        HStack {
            Button (action: {
                
            }) {
                Image(systemName: "backward.fill")
            }
            Button (action: {
                
            }) {
                Image(systemName: "play.fill")
            }
            Button (action: {
                
            }) {
                Image(systemName: "forward.fill")
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
