//
//  MusicController.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/09/24.
//

import SwiftUI

struct MusicController: View {
    @EnvironmentObject private var viewModel: MusicViewModel
    @Binding var musicControlButtonWidth: Double
    var hstackSpacing: Double
    var body: some View {
        HStack(spacing: hstackSpacing) {
            Button {
                viewModel.setupPreviousTrack(mixedSound: viewModel.mixedSound ?? MixedSound.empty)
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .frame(width: musicControlButtonWidth, height: musicControlButtonWidth * 0.71)
                    .tint(.white)
            }.disabled(viewModel.mixedSound == nil)

            Button {
                viewModel.playPause()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: musicControlButtonWidth * 0.9, height: musicControlButtonWidth * 1.125)
                    .tint(.white)
            }.disabled(viewModel.mixedSound == nil)

            Button {
                viewModel.setupNextTrack(mixedSound: viewModel.mixedSound ?? MixedSound.empty)
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .frame(width: musicControlButtonWidth, height: musicControlButtonWidth * 0.71)
                    .tint(.white)
            }.disabled(viewModel.mixedSound == nil)
        }
    }
}
//
//struct MusicController_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicController()
//    }
//}
