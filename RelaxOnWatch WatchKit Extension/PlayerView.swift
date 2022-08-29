//
//  PlayerView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import SwiftUI

struct PlayerView: View {
    @StateObject var playerViewModel = PlayerViewModel()
    @State var volume = 10.0
    
    var body: some View {
        ZStack {
            Image("MusicBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10)
            
            VStack {
                Text(playerViewModel.currentCDName)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        playerViewModel.playPrevious()
                    }) {
                        Image(systemName: "backward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                                    
                    Button(action: {
                        playerViewModel.playPause()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.black)
                                .frame(width: 50, height: 50)
                        Image(systemName: playerViewModel.cdinfos[0] == "false" ? "play.fill" : "pause.fill")
                                .font(.system(size: 30))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: {
                        playerViewModel.playNext()
                    }) {
                        Image(systemName: "forward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                
                Slider(
                    value: $volume,
                    in: 0...100,
                    onEditingChanged: { _ in print("slider is editing")
                    }
                )
                .tint(.white)
            }
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
