//
//  MixedSoundCard.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/25.
//

import SwiftUI


struct MixedSoundCard : View {
    var data: MixedSound
    let selectedID: String?
    @State var show = false
    
    init(data: MixedSound,
         selectedID: String? = nil) {
        self.data = data
        self.selectedID = selectedID
    }

    var body : some View {
        ZStack {
            NavigationLink(destination: MusicView(data: data),
                           isActive: $show) {
                Text("")
                
            }

            VStack(alignment: .leading, spacing: 10) {
                Image(data.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                Text(data.name)
                    .fontWeight(.semibold)
                    .font(Font.system(size: 17))
                    .foregroundColor(Color.white)
            }
            .onTapGesture {
                show.toggle()
            }
        }
    }
}

struct MixedSoundCard_Previews: PreviewProvider {
    static var previews: some View {
        let dummyMixedSound = MixedSound(id: 3,
                                        name: "test4",
                                        sounds: [Sound(id: 0, name: BaseAudioName.chineseGong.fileName, imageName: "gong1"),
                                                 Sound(id: 2, name: MelodyAudioName.lynx.fileName, imageName: "r1"),
                                                 Sound(id: 6,
                                                       name: NaturalAudioName.creekBabbling.fileName,
                                                       imageName: "r3")
                                                ],
                                        imageName: "r1")
        MixedSoundCard(data: dummyMixedSound,
                       selectedID: "")
        .background(ColorPalette.background.color)
    }
}
