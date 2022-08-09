//
//  PlayerView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import SwiftUI

struct PlayerView: View {
    @StateObject var playerViewModel = PlayerViewModel()
    
    var body: some View {
        VStack {
            Text(playerViewModel.cdinfos[1])
            
            HStack {
                Button(action: {
                    playerViewModel.playPrevious()
                }) {
                    Image(systemName: "backward.fill")
                }
                Button(action: {
                    playerViewModel.playPause()
                }) {
                    Image(systemName: playerViewModel.cdinfos[0] == "false" ? "play.fill" : "pause.fill")
                }
                Button(action: {
                    playerViewModel.playNext()
                }) {
                    Image(systemName: "forward.fill")
                }
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
