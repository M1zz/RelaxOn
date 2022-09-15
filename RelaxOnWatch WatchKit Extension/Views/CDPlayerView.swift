//
//  CDPlayerView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import SwiftUI

struct CDPlayerView: View {
    @ObservedObject var watchConnectivityManager: WatchConnectivityManager
    @ObservedObject var cdPlayerManager = CDPlayerManager.shared
    @State var volume = 50.0
    
    var body: some View {
        ZStack {
            Image("MusicBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10)
            
            VStack {
                Text(cdPlayerManager.currentCDName)
                
                HStack {
                    Button(action: {
                        cdPlayerManager.playPrevious()
                    }) {
                        Image(systemName: "backward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .disabled(cdPlayerManager.currentCDName == "")
                    .buttonStyle(.plain)
                    
                    Spacer()
                                    
                    Button(action: {
                        cdPlayerManager.playPause()
                    }) {
                        ZStack {
                            Circle()
                                .fill(.black)
                                .frame(width: 50, height: 50)
                            Image(systemName: cdPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                        }
                    }
                    .disabled(cdPlayerManager.currentCDName == "")
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button(action: {
                        cdPlayerManager.playNext()
                    }) {
                        Image(systemName: "forward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .disabled(cdPlayerManager.currentCDName == "")
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
    }
}

struct CDPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CDPlayerView(watchConnectivityManager: WatchConnectivityManager.shared)
    }
}
