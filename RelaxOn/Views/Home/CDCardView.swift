//
//  CDCardView.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/28.
//

import SwiftUI

struct CDCardView: View {
    var data: MixedSound
    @State var isShwoingMusicView = false
    @State var audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float) = (baseVolume: 0.0, melodyVolume: 0.0, naturalVolume: 0.0)
    @Binding var userRepositoriesState: [MixedSound]
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.isShwoingMusicView.toggle()
            }, label: {
                
                    ZStack {
                        Image(data.baseSound?.imageName ?? "")
                            .resizable()
                            .opacity(0.5)
                            .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        Image(data.melodySound?.imageName ?? "")
                            .resizable()
                            .opacity(0.5)
                            .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                        Image(data.naturalSound?.imageName ?? "")
                            .resizable()
                            .opacity(0.5)
                            .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                    }
                    .fullScreenCover(isPresented: $isShwoingMusicView) {
                        NewMusicView(data: data, audioVolumes: $audioVolumes, userRepositoriesState: $userRepositoriesState)
                    }
            })
            Text(data.name)
        }
    }
}
//
//struct CDCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CDCardView(data: dummyMixedSound)
//    }
//}
