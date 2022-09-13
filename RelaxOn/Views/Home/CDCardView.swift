//
//  CDCardView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/07/28.
//

import SwiftUI

struct CDCardView: View {
    var data: MixedSound
    @Binding var isShowingMusicView: Bool
    @Binding var userRepositoriesState: [MixedSound]
    @State var selectedMixedSound: MixedSound?
    @State private var isPresent = false
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.selectedMixedSound = data
                self.isShowingMusicView.toggle()
            }, label: {
                ZStack {
                    if let baseSoundImageName = data.baseSound?.fileName {
                        switch baseSoundImageName {
                        case "music":
                            EmptyView()
                        default:
                            Image(baseSoundImageName)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        }
                    }
                    
                    if let melodySoundImageName = data.melodySound?.fileName {
                        switch melodySoundImageName {
                        case "music":
                            EmptyView()
                        default:
                            Image(melodySoundImageName)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        }
                    }
                    
                    if let whiteNoiseSoundImageName = data.whiteNoiseSound?.fileName {
                        switch whiteNoiseSoundImageName {
                        case "music":
                            EmptyView()
                        default:
                            Image(whiteNoiseSoundImageName)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        }
                    }
                }
                .fullScreenCover(item: $selectedMixedSound) { _ in
                    NewMusicView(data: data, userRepositoriesState: $userRepositoriesState)
                }
                .fullScreenCover(isPresented: $isPresent) {
                    NewMusicView(data: data, userRepositoriesState: $userRepositoriesState)
                }
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
