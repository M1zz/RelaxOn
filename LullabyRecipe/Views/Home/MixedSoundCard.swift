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
//                Text(data.description)
//                    .fontWeight(.semibold)
//                    .font(Font.system(size: 16))
//                    .foregroundColor(Color.gray)
            }
            .onTapGesture {
                show.toggle()
            }
        }
    }
}

struct MixedSoundCard_Previews: PreviewProvider {
    static var previews: some View {
        MixedSoundCard(data: userRepositories[0],
                       selectedID: "")
        .background(ColorPalette.background.color)
    }
}
