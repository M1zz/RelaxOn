//
//  VolumeSliderView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/10/31.
//

import SwiftUI

struct VolumeSliderView: View {
    @Binding var audioManager: AudioManager

    var body: some View {
        Slider(value: $audioManager.volume, in: 0...1)
            .background(.black)
            .cornerRadius(4)
            .accentColor(.white)
            .padding(.horizontal, 20)
            .onChange(of: audioManager.volume) { newValue in
                audioManager.changeVolume(volume: newValue)
                
            }
            Text(String(Int(audioManager.volume * 100)))
                .foregroundColor(.systemGrey1)
                .onAppear {
                    print("volume", audioManager.volume)
                }
    }
}

//struct VolumeSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        VolumeSliderView(audioManager: AudioManager(), trackName: BaseSound.longSun.fileName)
//    }
//}
