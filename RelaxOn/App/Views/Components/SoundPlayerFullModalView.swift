//
//  SoundPlayerFullModalView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 풀 모달 화면으로 보여지는 음원 플레이어 VIew
 */
struct SoundPlayerFullModalView: View {

    @EnvironmentObject var viewModel: CustomSoundViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(viewModel.selectedSound?.category.imageName ?? viewModel.lastSound.category.imageName)
                .resizable()
                .scaledToFit()
                .background(Color(hex: viewModel.selectedSound?.color ?? viewModel.lastSound.color))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            Spacer()
            
            Text(viewModel.selectedSound?.title ?? viewModel.lastSound.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.Text))
            
            HStack(alignment: .center, spacing: 40) {
                
                Button {
                    viewModel.playPreviousSound()
                } label: {
                    Image(PlayerButton.fastRewind.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
                
                Button {
                    if viewModel.isPlaying {
                        viewModel.stopSound()
                    } else {
                        viewModel.play(with: viewModel.selectedSound ?? viewModel.lastSound)
                    }
                } label: {
                    Image(viewModel.playPauseStatusImage)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
                
                Button {
                    viewModel.playNextSound()
                } label: {
                    Image(PlayerButton.fastForward.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
            }
            .frame(minWidth: 200, maxWidth: .infinity)
            .padding(.top, 32)
            
            Spacer()
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Color(.DefaultBackground))
        
        .onAppear {
            if let selectedSound = viewModel.selectedSound {
                viewModel.lastSound = selectedSound
            }
            if viewModel.isPlaying {
                viewModel.stopSound()
                viewModel.play(with: viewModel.selectedSound ?? viewModel.lastSound)
            } else {
                viewModel.play(with: viewModel.selectedSound ?? viewModel.lastSound)
            }
        }
        .onDisappear {
            if let selectedSound = viewModel.selectedSound {
                viewModel.lastSound = selectedSound
            }
        }
    }
}

struct FullModalSoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerFullModalView()
    }
}
