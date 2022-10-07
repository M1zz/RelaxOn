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
                    PlayControlButton(
                        of: "backward.end",
                        run: viewModel.playPrevious,
                        isDisabled: viewModel.isPlayerEmpty()
                    )
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(.black)
                            .frame(width: 50, height: 50)
                        PlayControlButton(
                            of: viewModel.isPlaying ? "pause.fill" : "play.fill",
                            run: viewModel.playPause,
                            isDisabled: viewModel.isPlayerEmpty()
                        )
                    }
                    
                    Spacer()
                    
                    PlayControlButton(
                        of: "forward.end",
                        run: viewModel.playNext,
                        isDisabled: viewModel.isPlayerEmpty()
                    )
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

extension CDPlayerView {
    func PlayControlButton(of name: String, run action: @escaping () -> Void, isDisabled: Bool) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: name)
                .font(.system(size: 20, weight: .medium))
        }
        .disabled(isDisabled)
        .buttonStyle(.plain)
    }
}

struct CDPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CDPlayerView()
    }
}
