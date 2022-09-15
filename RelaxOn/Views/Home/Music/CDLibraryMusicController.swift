//
//  CDLibraryMusicController.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/09/08.
//

import SwiftUI

struct CDLibraryMusicController: View {
    @EnvironmentObject var viewModel: MusicViewModel
    private let cdCoverImageEdgeSize = deviceFrame.screenHeight * 0.06
    var body: some View {
        VStack {
            HStack {
                if let selectedImageNames = viewModel.mixedSound?.getImageName() {
                    CDCoverImageView(selectedImageNames: selectedImageNames)
                        .frame(width: cdCoverImageEdgeSize, height: cdCoverImageEdgeSize)
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.leading, 16)
                } else {
                    Image("placeholderImage")
                        .resizable()
                        .cornerRadius(4)
                        .frame(width: cdCoverImageEdgeSize, height: cdCoverImageEdgeSize)
                        .padding(.leading, 16)
                        .opacity(0.6)
                }
                
                Text(viewModel.mixedSound?.name.description ?? "재생 중이 아님")
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                
                Spacer()
                
                HStack(spacing: 22) {
                    Button {
                        viewModel.setupPreviousTrack(mixedSound: viewModel.mixedSound ?? emptyMixedSound)
                    } label: {
                        Image(systemName: "backward.fill")
                            .tint(.white)
                    }.disabled(viewModel.mixedSound == nil)
                    
                    Button {
                        viewModel.playPause()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .tint(.white)
                    }.disabled(viewModel.mixedSound == nil)
                    
                    Button {
                        viewModel.setupNextTrack(mixedSound: viewModel.mixedSound ?? emptyMixedSound)
                    } label: {
                        Image(systemName: "forward.fill")
                            .tint(.white)
                    }.disabled(viewModel.mixedSound == nil)
                }
                .padding(.horizontal, 17)
            }
            .padding(.top, 17)
            
            Spacer()
        }
        .frame(height: deviceFrame.screenHeight * 0.1)
        .background(
            Color.relaxRealBlack
        )
        
    }
}

struct CDLibraryMusicController_Previews: PreviewProvider {
    static var previews: some View {
        CDLibraryMusicController()
    }
}
