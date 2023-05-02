//
//  SoundDetailView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI
import AVFoundation

struct SoundDetailView: View {
    
    // MARK: - Properties
    @State var isShowingSheet: Bool = false
    @State var originalSound: Sound
    @ObservedObject var audioManager = AudioManager()
    
    var body: some View {
        VStack {
            Text("Drag to find your sound")
                .foregroundColor(.black)
                .font(.title)
            
            ZStack {
                Image("CustomSoundSpace")
                    .zIndex(0)
                Text("💧")
                    .font(.system(size: 34))
                    .frame(width: 30, height: 30)
                    .offset(x: -15, y: 10)
                    .zIndex(1)
            }
            .padding(24)
            
            Text("Volume Slider")
                .font(.title3)
            
            Slider(value: audioManager.currentVolume, in: 0.0 ... 1.0)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
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
            
            .fullScreenCover(isPresented: $isShowingSheet) {
                SoundSaveView(mixedSound: MixedSound(
                    name: originalSound.name,
                    volume: audioManager.volume,
                    imageName: originalSound.imageName)
                )
                
            }
        }
        
        // MARK: - Life Cycle
        .onAppear() {
            audioManager.playAudio(sound: originalSound)
        }
        .onDisappear() {
            audioManager.stopAudio()
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(originalSound: Sound(name: "Water Drop"))
    }
}
