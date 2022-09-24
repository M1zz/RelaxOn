//
//  MusicController.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/09/24.
//

import SwiftUI

struct MusicController: View {
    @EnvironmentObject private var viewModel: MusicViewModel
    @State private var musicControlButtonWidth: CGFloat
    @State private var musicPlayButtonWidth: CGFloat
    
    init(musicControlButtonWidth: CGFloat) {
        self.musicControlButtonWidth = musicControlButtonWidth
        self.musicPlayButtonWidth = musicControlButtonWidth * 0.9
    }
    var body: some View {
        HStack(spacing: 56) {
            Button {
                viewModel.setupPreviousTrack(mixedSound: viewModel.mixedSound ?? emptyMixedSound)
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .frame(width: musicControlButtonWidth, height: musicControlButtonWidth * 0.71)
                    .tint(.white)
            }

            Button {
                viewModel.playPause()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: musicPlayButtonWidth, height: musicPlayButtonWidth * 1.25) //1.25
                    .tint(.white)
            }

            Button {
                viewModel.setupNextTrack(mixedSound: viewModel.mixedSound ?? emptyMixedSound)
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .frame(width: musicControlButtonWidth, height: musicControlButtonWidth * 0.71)
                    .tint(.white)
            }
        }
    }
}

struct MusicController_Previews: PreviewProvider {
    static var previews: some View {
        MusicController()
    }
}
