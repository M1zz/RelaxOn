//
//  CDCardView.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/28.
//

import SwiftUI

struct CDCardView: View {
    var data: MixedSound
    @State var audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float) = (baseVolume: 0.0, melodyVolume: 0.0, naturalVolume: 0.0)
    @State var ispresent = false
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(isActive: $ispresent) {
                MusicView(data: data, audioVolumes: $audioVolumes)
            } label: {
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
                .onTapGesture {
                    ispresent = true
                }
            }
            Text(data.name)
        }
        #warning("onOpenURL 넣기")
//        .onOpenURL { url in
//            ispresent = url == data.url
//        }
    }
}

struct CDCardView_Previews: PreviewProvider {
    static var previews: some View {
        CDCardView(data: dummyMixedSound)
    }
}
