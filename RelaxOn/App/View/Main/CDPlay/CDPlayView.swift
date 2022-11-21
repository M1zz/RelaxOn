//
//  CDPlayView.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//
//1. 음악볼륨을 바꿀 때 메테리얼 자체에 적용이 되고 있는가
//2. 다음 곡이나 이전 곡을 재생하면 해당 메테리얼의 볼륨이 잘 적용되는지

import SwiftUI

struct CDPlayView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //    @Binding var cd: CD?
    @StateObject var cdPlayViewModel = CDPlayViewModel()
    @EnvironmentObject var cdManager: CDManager
    
    var body: some View {
        VStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("닫기")
            }
            ZStack {
                if let baseFileName = cdManager.playingCD?.base?.fileName,
                   let melodyFileName = cdManager.playingCD?.melody?.fileName,
                   let whiteNoiseFileName = cdManager.playingCD?.whiteNoise?.fileName {
                    NewCDCoverImageView(selectedImageNames: (baseFileName: baseFileName, melodyFileName: melodyFileName, whiteNoiseFileName: whiteNoiseFileName))
                }
            }
            Text(cdManager.playingCD?.name ?? "error")
            HStack {
                Button {
                    cdPlayViewModel.clickedPreCD()
                } label: {
                    Text("이전")
                }
                Button {
                    cdPlayViewModel.clickedplayPause()
                } label: {
                    if cdManager.isPlaying {
                        Text("멈추기")
                    } else {
                        Text("재생")
                    }
                }
                Button {
                    cdPlayViewModel.clickedNextCD()
                } label: {
                    Text("다음")
                }
            }
            VStack {
//                VolumeSliderView(material: $cdManager.playingCD?.base)
            }
        }
        .onAppear {
            cdPlayViewModel.setUp(cdManager: cdManager)
        }
    }
}

//struct CDPlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        CDPlayView(cd: .constant(CD(name: "hi")))
//    }
//}
