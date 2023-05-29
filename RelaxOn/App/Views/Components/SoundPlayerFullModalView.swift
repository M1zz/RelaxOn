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
    
    /// UI 확인용
    var file: CustomSound
    @State private var isPlaying: Bool = false
    
    @EnvironmentObject var viewModel: CustomSoundViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(file.category.imageName)
                .resizable()
                .scaledToFit()
                .background(Color(hex: "DCE8F5"))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            Spacer()
            
            Text(file.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.Text))
            
            HStack(alignment: .center, spacing: 40) {
                
                Button {
                    // TODO: 저장된 음원 목록 중 뒤쪽 음원으로 이동
                } label: {
                    Image(PlayerButton.fastRewind.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
                
                Button {
                    // TODO: 선택한 사운드 재생/일시정지 토글
                    isPlaying.toggle()
                } label: {
                    Image(isPlaying ? PlayerButton.pause.rawValue : PlayerButton.play.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
                
                Button {
                    // TODO: 저장된 음원 목록 중 앞쪽 음원으로 이동
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
    }
}

struct FullModalSoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerFullModalView(file: .init(fileName: "나의 물방울 소리", category: .waterDrop, audioVariation: AudioVariation(), audioFilter: .WaterDrop))
    }
}
