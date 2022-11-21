//
//  StudioView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/10/31.
//

import SwiftUI

struct NewStudioView: View {
    @State var selectedIndex: Int = 0
    var items = MaterialType.allCases
    @EnvironmentObject var cdManager: CDManager
    @State var trackName = Base.oxygen.fileName
    
    var body: some View {
        VStack {
            Text("스튜디오뷰")
            NewCustomSegmentControlView(items: items, selection: $selectedIndex)
                .background(.black)
//            switch selectedIndex {
//                case 0:
//                    VolumeSliderView(audioManager: $cdManager.audioMaterialManager.baseAudioManager)
//                case 1:
//                    VolumeSliderView(audioManager: $cdManager.audioMaterialManager.melodyAudioManager)
//                default:
//                    VolumeSliderView(audioManager: $cdManager.audioMaterialManager.whiteNoiseAudioManager)
//            }
            
        }
    }
}

struct NewStudioView_Previews: PreviewProvider {
    static var previews: some View {
        NewStudioView()
    }
}
