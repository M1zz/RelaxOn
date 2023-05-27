//
//  SoundDetailView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI
import AVFoundation

/**
 사용자가 Sound를 커스텀하는 View
 */
struct SoundDetailView: View {
    
    // MARK: - Properties
    @State var isShowingSheet: Bool = false
    @State var originalSound: OriginalSound
    @EnvironmentObject var viewModel: CustomSoundViewModel
    
    var body: some View {
        VStack {
            VStack {
                Text("당신이 원하는 소리를 찾아가보세요")
                    .bold()
                    .foregroundColor(.black)
                    .padding(8)
                Text("자유롭게 이동하며 실험해보세요")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
            ZStack {
                backgroundCircle()
                ForEach(0..<circleWidth.count) { index in
                    CircularSlider(width: circleWidth[index], imageName: featureIcon[index])
                }
                
            }
            .padding(24)
        }
        
        .navigationBarTitle(originalSound.name, displayMode: .inline)
        .font(.system(size: 24, weight: .bold))
        
        .toolbar {
            Button {
                print("tapped done button")
                isShowingSheet.toggle()
            } label: {
                Text("Done")
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 20))
            }
            
            .fullScreenCover(isPresented: $isShowingSheet, onDismiss: {
                // TODO: Modal이 Dismiss됐을 때 소리 다시 재생하는 기능
            }) {
                SoundSaveView(originalSound: originalSound, audioVariation: AudioVariation(volume: viewModel.volume, pitch: viewModel.pitch, speed: viewModel.speed))
            }
        }
        
        // MARK: - Life Cycle
        .onAppear() {
            viewModel.playSound(originSound: originalSound)
        }
        .onDisappear() {
            viewModel.stopSound()
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(originalSound: OriginalSound(name: "물소리", filter: .waterDrop, category: .waterDrop, defaultColor: "DCE8F5"))
    }
}
