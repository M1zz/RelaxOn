//
//  PlayerView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import SwiftUI

struct PlayerView: View {
//    @ObservedObject var playerViewModel: PlayerViewModel
    @State var volume = 10.0
    @State var currentCDName: String = ""
    
    
    var body: some View {
        ZStack {
            Image("MusicBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10)
            
            VStack {
                Text(currentCDName)
                let _ = print("player view: \(PlayerViewModel.shared.currentCDName)")
                
                Spacer()
                
                HStack {
                    Button(action: {
                        PlayerViewModel.shared.playPrevious()
                    }) {
                        Image(systemName: "backward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                                    
                    Button(action: {
                        PlayerViewModel.shared.playPause()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.black)
                                .frame(width: 50, height: 50)
                            Image(systemName: PlayerViewModel.shared.cdinfos[0] == "false" ? "play.fill" : "pause.fill")
                                .font(.system(size: 30))
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: {
                        PlayerViewModel.shared.playNext()
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
        .onAppear {
            currentCDName = PlayerViewModel.shared.currentCDName
            print("onAppear: \(PlayerViewModel.shared.currentCDName)")
        }
    }
}

//struct PlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerView(playerViewModel: <#PlayerViewModel#>)
//    }
//}
