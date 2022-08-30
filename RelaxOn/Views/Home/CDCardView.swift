//
//  CDCardView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/07/28.
//

import SwiftUI

struct CDCardView: View {
    var data: MixedSound
    @Binding var isShwoingMusicView: Bool
    @Binding var userRepositoriesState: [MixedSound]
    @State var selectedMixedSound: MixedSound?
    @State private var isPresent = false
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.selectedMixedSound = data
                self.isShwoingMusicView.toggle()
            }, label: {
                    ZStack {
                        if let baseSoundImageName = data.baseSound?.fileName {
                            Image(baseSoundImageName)
                                .resizable()
                                .opacity(baseSoundImageName == "music" ? 0 : 0.5)
                                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        }
                        if let melodySoundImageName = data.melodySound?.fileName {
                            Image(melodySoundImageName)
                                .resizable()
                                .opacity(melodySoundImageName == "music" ? 0 : 0.5)
                                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        }
                        if let whiteNoiseSoundImageName = data.whiteNoiseSound?.fileName {
                            Image(whiteNoiseSoundImageName)
                                .resizable()
                                .opacity(whiteNoiseSoundImageName == "music" ? 0 : 0.5)
                                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        }
                    }
                    .fullScreenCover(item: $selectedMixedSound) { _ in
                        NewMusicView(data: data, userRepositoriesState: $userRepositoriesState)
                    }
                    .fullScreenCover(isPresented: $isPresent, content: {
                        NewMusicView(data: data, userRepositoriesState: $userRepositoriesState)
                    })
            })
            Text(data.name)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.systemGrey1)
        }
        .onOpenURL { url in
            isPresent = url == data.url
        }
    }
}
//
//struct CDCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CDCardView(data: dummyMixedSound)
//    }
//}
