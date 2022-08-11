//
//  CDCardView.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/28.
//

import SwiftUI

struct CDCardView: View {
    var data: MixedSound
    @State var audioVolumes: (baseVolume: Float, melodyVolume: Float, whiteNoiseVolume: Float) = (baseVolume: 0.0, melodyVolume: 0.0, whiteNoiseVolume: 0.0)
    @State private var isPresent = false
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(isActive: $isPresent) {
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
                    Image(data.whiteNoiseSound?.imageName ?? "")
                        .resizable()
                        .opacity(0.5)
                        .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                }
                .cornerRadius(4)
            }
            Text(data.name)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.systemGrey1)
        }
        .onOpenURL { url in
            isPresent = url == data.url
        }
    }
}

struct CDCardView_Previews: PreviewProvider {
    static var previews: some View {
        CDCardView(data: dummyMixedSound)
    }
}
