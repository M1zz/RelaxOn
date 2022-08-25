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
                    .fullScreenCover(item: $selectedMixedSound) { _ in
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
