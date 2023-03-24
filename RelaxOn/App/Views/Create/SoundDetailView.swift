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
    //@State var volume: Float = 0.5
    @State var isShowingSheet: Bool = false
    @State var mixedSound: MixedSound
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
            }//ZStack
            .padding(24)
            
            Text("Volume Slider")
                .font(.title3)
            // 변경되는 volume 값을 전달하기 위한 임시 슬라이더
            Slider(value: audioManager.currentVolume, in: 0.0 ... 1.0)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }//VStack
        
        .navigationBarTitle(mixedSound.fileName, displayMode: .inline)
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
            .sheet(isPresented: $isShowingSheet) {
                SoundSaveView(volume: audioManager.currentVolume)
            }
        }
        
        // MARK: - Life Cycle
        .onAppear() {
            audioManager.playAudio(mixedSound: mixedSound)
        }
        .onDisappear() {
            audioManager.stopAudio()
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(mixedSound: MixedSound(fileName: "Water Drop", volume: 0.5))
    }
}
