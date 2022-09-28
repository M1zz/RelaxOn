//
//  CDPlayerView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import SwiftUI

struct CDPlayerView: View {
    @ObservedObject var viewModel = CDPlayerViewModel()
    
    var body: some View {
        ZStack {
            Image("MusicBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10)
            
            VStack {
                Text(viewModel.currentCDName)
                
                HStack {
                    Button {
                        viewModel.playPreviouse()
                    } label: {
                        Image(systemName: "backward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .disabled(viewModel.isPlayerEmpty())
                    .buttonStyle(.plain)
                    
                    Spacer()
                                    
                    Button {
                        viewModel.playPause()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.black)
                                .frame(width: 50, height: 50)
                            Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                        }
                    }
                    .disabled(viewModel.isPlayerEmpty())
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        viewModel.playNext()
                    } label: {
                        Image(systemName: "forward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .disabled(viewModel.isPlayerEmpty())
                    .buttonStyle(.plain)
                }
                .padding()
                
                Slider(value: Binding(
                    get: {
                        CDPlayer.shared.volume
                    },
                    set: {(newValue) in
                        viewModel.changeVolume(volume: newValue)
                    }
                ))
                .tint(.white)
            }
        }
        .onAppear {
            viewModel.getSystemVolume()
        }
    }
}

struct CDPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CDPlayerView()
    }
}
