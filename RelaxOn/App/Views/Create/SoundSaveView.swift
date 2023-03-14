//
//  SoundSaveView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundSaveView: View {
    var createdSound: MixedSound
    var body: some View {
        Text("SoundSaveView \(createdSound.name)")
        Text("\(createdSound.audioVolume ?? 0.0)")
    }
}
//
//struct ThirdView_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundSaveView(fileInfo: CreatedSound(name: "세번째"))
//    }
//}
