//
//  VolumeControl.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/29.
//

import SwiftUI

struct VolumeControl: View {
    
    @Binding var showVolumeControl: Bool
    @Binding var baseVolume: Float
    @Binding var melodyVolume: Float
    @Binding var naturalVolume: Float
    
    let data: MixedSound
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()
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
                        //showVolumeControl.toggle()
                        baseAudioManager.stop()
                        melodyAudioManager.stop()
                        naturalAudioManager.stop()
                        // TODO: - 볼륨 저장
                        let localBaseSound = data.baseSound
                        let localMelodySound = data.melodySound
                        let localNaturalSound = data.naturalSound
                        
                        let newBaseSound = Sound(id: localBaseSound!.id,
                                                 name: localBaseSound!.name,
                                                 soundType: localBaseSound!.soundType,
                                                 audioVolume: baseVolume,
                                                 imageName: localBaseSound!.imageName)
                        let newMelodySound = Sound(id: localMelodySound!.id,
                                                   name: localMelodySound!.name,
                                                   soundType: localMelodySound!.soundType,
                                                   audioVolume: melodyVolume,
                                                   imageName: localMelodySound!.imageName)
                        
                        let newNaturalSound = Sound(id: localNaturalSound!.id,
                                                    name: localNaturalSound!.name,
                                                    soundType: localNaturalSound!.soundType,
                                                    audioVolume: naturalVolume,
                                                    imageName: localNaturalSound!.imageName)
                        
                        let newMixedSound = MixedSound(id: data.id,
                                                       name: data.name,
                                                       baseSound: newBaseSound,
                                                       melodySound: newMelodySound,
                                                       naturalSound: newNaturalSound,
                                                       imageName: data.imageName)
                        
                        userRepositories.remove(at: data.id)
                        userRepositories.insert(newMixedSound, at: data.id)
                        let data = getEncodedData(data: userRepositories)
                        UserDefaults.standard.set(data, forKey: "recipes")
                        
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
                
                if let naturalSound = data.naturalSound {
                    SoundControlSlider(item: naturalSound)
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
//struct VolumeControl_Previews: PreviewProvider {
//    static var previews: some View {
//        VolumeControl(showVolumeControl: .constant(true),
//                      baseVolume: 0.3,
//                      melodyVolume: 0.8,
//                      naturalVolume: 1.0,
//                      data: dummyMixedSound, newData: <#Binding<MixedSound>#>)
//    }
//}
