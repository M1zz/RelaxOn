//
//  StudioView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/10/31.
//

import SwiftUI

struct NewStudioView: View {
    @State var selectedIndex: Int = 0
    var items = SoundType.allCases
    @EnvironmentObject var cdManager: CDManager
    @State var trackName = BaseSound.oxygen.fileName
    
    var body: some View {
        VStack {
            Text("스튜디오뷰")
            CustomSegmentControlView(items: items, selection: $selectedIndex)
                .background(.black)
            switch selectedIndex {
            case 0:
                VolumeSliderView(audioManager: $cdManager.baseAudioManager, volume: cdManager.baseAudioManager.player?.volume ?? 0.0)
            case 1:
                VolumeSliderView(audioManager: $cdManager.melodyAudioManager, volume: cdManager.melodyAudioManager.player?.volume ?? 0.0)
            default:
                VolumeSliderView(audioManager: $cdManager.whiteNoiseAudioManager, volume: cdManager.whiteNoiseAudioManager.player?.volume ?? 0.0)
            }
            
        }
    }
}

struct NewStudioView_Previews: PreviewProvider {
    static var previews: some View {
        NewStudioView()
    }
}
