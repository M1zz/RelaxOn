//
//  VolumeControlView.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/29.
//

import SwiftUI

struct VolumeControlView: View {
    
    @Binding var showVolumeControl: Bool
    @Binding var audioVolumes: (baseVolume: Float, melodyVolume: Float, whiteNoiseVolume: Float)
    
    let data: MixedSound
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let whiteNoiseAudioManager = AudioManager()
    @State var hasShowAlert: Bool = false
    
    var body: some View {
        ZStack {
            ColorPalette.tabBackground.color.ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        showVolumeControl.toggle()
                        baseAudioManager.stop()
                        melodyAudioManager.stop()
                        whiteNoiseAudioManager.stop()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Volume Control").WhiteTitleText()
                    Spacer()
                    Button {
                        //showVolumeControl.toggle()
                        baseAudioManager.stop()
                        melodyAudioManager.stop()
                        whiteNoiseAudioManager.stop()
                        // TODO: - 볼륨 저장
                        guard let localBaseSound = data.baseSound,
                              let localMelodySound = data.melodySound,
                              let localWhiteNoiseSound = data.whiteNoiseSound else { return }
                        
                        let newBaseSound = Sound(id: localBaseSound.id,
                                                 name: localBaseSound.name,
                                                 soundType: localBaseSound.soundType,
                                                 audioVolume: audioVolumes.baseVolume,
                                                 imageName: localBaseSound.imageName)
                        let newMelodySound = Sound(id: localMelodySound.id,
                                                   name: localMelodySound.name,
                                                   soundType: localMelodySound.soundType,
                                                   audioVolume: audioVolumes.melodyVolume,
                                                   imageName: localMelodySound.imageName)
                        
                        let newWhiteNoiseSound = Sound(id: localWhiteNoiseSound.id,
                                                    name: localWhiteNoiseSound.name,
                                                    soundType: localWhiteNoiseSound.soundType,
                                                    audioVolume: audioVolumes.whiteNoiseVolume,
                                                    imageName: localWhiteNoiseSound.imageName)
                        
                        let newMixedSound = MixedSound(id: data.id,
                                                       name: data.name,
                                                       baseSound: newBaseSound,
                                                       melodySound: newMelodySound,
                                                       whiteNoiseSound: newWhiteNoiseSound,
                                                       imageName: data.imageName)
                        
                        userRepositories.remove(at: data.id)
                        userRepositories.insert(newMixedSound, at: data.id)
                        let data = getEncodedData(data: userRepositories)
                        UserDefaultsManager.shared.standard.set(data, forKey: UserDefaultsManager.shared.recipes)
                        
                        hasShowAlert = true
                    } label: {
                        Text("Save")
                            .foregroundColor(ColorPalette.forground.color)
                            .fontWeight(.semibold)
                            .font(Font.system(size: 22))
                    }
                    
                    
                }
                .alert(isPresented: $hasShowAlert) {
                    Alert(
                        title: Text("Volume has changed, Restart the app please."),
                        dismissButton: .default(Text("Got it!")) {
                            showVolumeControl.toggle()
                        }
                    )
                }
                
                
                
                .padding()
                
                if let baseSound = data.baseSound {
                    SoundControlSlider(item: baseSound)
                }
                
                if let melodySound = data.melodySound {
                    SoundControlSlider(item: melodySound)
                }
                
                if let whiteNoiseSound = data.whiteNoiseSound {
                    SoundControlSlider(item: whiteNoiseSound)
                }
                
                Spacer()
            }
        }
    }

    
    @ViewBuilder
    func SoundControlSlider(item: Sound) -> some View {
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
                    Slider(value: $audioVolumes.baseVolume, in: 0...1)
                        .background(.black)
                        .cornerRadius(4)
                        .accentColor(.white)
                        .padding(.horizontal, 20)
                        .onChange(of: audioVolumes.baseVolume) { newValue in
                            print(newValue)
                            baseAudioManager.changeVolume(track: item.name,
                                                           volume: newValue)
                        }
                case .melody:
                    Slider(value: $audioVolumes.melodyVolume, in: 0...1)
                        .background(.black)
                        .cornerRadius(4)
                        .accentColor(.white)
                        .padding(.horizontal, 20)
                        .onChange(of: audioVolumes.melodyVolume) { newValue in
                            print(newValue)
                            melodyAudioManager.changeVolume(track: item.name,
                                                             volume: newValue)
                        }
                case .whiteNoise:
                    Slider(value: $audioVolumes.whiteNoiseVolume, in: 0...1)
                        .background(.black)
                        .cornerRadius(4)
                        .accentColor(.white)
                        .padding(.horizontal, 20)
                        .onChange(of: audioVolumes.whiteNoiseVolume) { newValue in
                            print(newValue)
                            whiteNoiseAudioManager.changeVolume(track: item.name,
                                                              volume: newValue)
                        }
                }
                
            }
        }
        .padding()
    }
    
    private func getEncodedData(data: [MixedSound]) -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            return encodedData
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        return nil
    }
}

// 오류 때문에 주석처리
//struct VolumeControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        VolumeControlView(showVolumeControl: .constant(true),
//                      baseVolume: 0.3,
//                      melodyVolume: 0.8,
//                      naturalVolume: 1.0,
//                      data: dummyMixedSound, newData: <#Binding<MixedSound>#>)
//    }
//}
