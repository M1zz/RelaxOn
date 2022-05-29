//
//  VolumeControl.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/29.
//

import SwiftUI

struct VolumeControl: View {
    
    let controledSounds: [Sound] = dummySounds
    @Binding var showVolumeControl: Bool
    @State var baseVolume: Float
    @State var melodyVolume: Float
    @State var naturalVolume: Float
    
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()
    
    var body: some View {
        ZStack {
            ColorPalette.tabBackground.color.ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        showVolumeControl.toggle()
                        baseAudioManager.stop()
                        melodyAudioManager.stop()
                        naturalAudioManager.stop()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    WhiteTitleText(title: "Volume Control")
                    Spacer()
                    Button {
                        showVolumeControl.toggle()
                        baseAudioManager.stop()
                        melodyAudioManager.stop()
                        naturalAudioManager.stop()
                        // TODO: - 볼륨 저장
                    } label: {
                        Text("Save")
                            .foregroundColor(ColorPalette.forground.color)
                            .fontWeight(.semibold)
                            .font(Font.system(size: 22))
                    }

                }
                .padding()
                
                ForEach(controledSounds) { item in
                    HStack {
                        VStack {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(24)
                            Text(item.name)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .frame(width: 120)
                        ZStack {
                            Rectangle()
                                .background(.black)
                                .frame(height: 40)
                                .cornerRadius(12)
                            switch item.soundType {
                            case .base:
                                Slider(value: $baseVolume, in: 0...1)
                                    .background(.black)
                                    .cornerRadius(4)
                                    .accentColor(.white)
                                    .padding(.horizontal, 20)
                                    .onChange(of: baseVolume) { newValue in
                                        print(newValue)
                                        baseAudioManager.chanegeVolume(track: item.name,
                                                                       volume: newValue)
                                    }
                            case .melody:
                                Slider(value: $melodyVolume, in: 0...1)
                                    .background(.black)
                                    .cornerRadius(4)
                                    .accentColor(.white)
                                    .padding(.horizontal, 20)
                                    .onChange(of: melodyVolume) { newValue in
                                        print(newValue)
                                        melodyAudioManager.chanegeVolume(track: item.name,
                                                                       volume: newValue)
                                    }
                            case .natural:
                                Slider(value: $naturalVolume, in: 0...1)
                                    .background(.black)
                                    .cornerRadius(4)
                                    .accentColor(.white)
                                    .padding(.horizontal, 20)
                                    .onChange(of: naturalVolume) { newValue in
                                        print(newValue)
                                        naturalAudioManager.chanegeVolume(track: item.name,
                                                                       volume: newValue)
                                    }
                            }
                            
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}

struct VolumeControl_Previews: PreviewProvider {
    static var previews: some View {
        VolumeControl(showVolumeControl: .constant(true),
                      baseVolume: 0.3,
                      melodyVolume: 0.8,
                      naturalVolume: 1.0)
    }
}
