//
//  VolumeControlView.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/29.
//

import SwiftUI

struct VolumeControlView: View {
    @ObservedObject var viewModel: MusicViewModel
    @Binding var showVolumeControl: Bool
    @Binding var audioVolumes: (baseVolume: Float, melodyVolume: Float, whiteNoiseVolume: Float)
    @Binding var userRepositoriesState: [MixedSound]
    
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let whiteNoiseAudioManager = AudioManager()
    @State var hasShowAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                UpperPartOfVolumeControlView()
                    .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                
                if let baseSound = viewModel.mixedSound?.baseSound {
                    SoundControlSlider(item: baseSound)
                }
                
                if let melodySound = viewModel.mixedSound?.melodySound {
                    SoundControlSlider(item: melodySound)
                }
                
                if let whiteNoiseSound = viewModel.mixedSound?.whiteNoiseSound {
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
                    .frame(width: 60, height: 60)
                    .cornerRadius(4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(.white, lineWidth: 1)
                    )
            }
            
            VStack (alignment: .leading){
                HStack {
                    Text(item.soundType.rawValue.uppercased())
                        .font(.system(size: 12, weight: .semibold, design: .default))
                        .foregroundColor(.systemGrey3)
                    
                    Text(item.name)
                        .font(.system(size: 17, weight: .semibold, design: .default))
                        .foregroundColor(.systemGrey1)
                }
                HStack(spacing: 0){
                    Image(systemName: "speaker.wave.1")
                        .tint(.systemGrey1)
                    
                    switch item.soundType {
                    case .base:
                        Slider(value: $audioVolumes.baseVolume, in: 0...1) { editing in
                            if !editing {
                                saveNewVolume()
                            }
                        }
                            .background(.black)
                            .cornerRadius(4)
                            .accentColor(.white)
                            .padding(.horizontal, 20)
                            .onChange(of: audioVolumes.baseVolume) { newValue in
                                print(newValue)
                                viewModel.baseAudioManager.changeVolume(track: item.name,
                                                              volume: newValue)
                            }
                        Text(String(Int(audioVolumes.baseVolume * 100)))
                            .foregroundColor(.systemGrey1)
                    case .melody:
                        Slider(value: $audioVolumes.melodyVolume, in: 0...1) { editing in
                            if !editing {
                                saveNewVolume()
                            }
                        }
                            .background(.black)
                            .cornerRadius(4)
                            .accentColor(.white)
                            .padding(.horizontal, 20)
                            .onChange(of: audioVolumes.melodyVolume) { newValue in
                                print(newValue)
                                viewModel.melodyAudioManager.changeVolume(track: item.name,
                                                                volume: newValue)
                            }
                        Text(String(Int(audioVolumes.melodyVolume * 100)))
                            .foregroundColor(.systemGrey1)
                    case .whiteNoise:
                        Slider(value: $audioVolumes.whiteNoiseVolume, in: 0...1) { editing in
                            if !editing {
                                saveNewVolume()
                            }
                        }
                            .background(.black)
                            .cornerRadius(4)
                            .accentColor(.white)
                            .padding(.horizontal, 20)
                            .onChange(of: audioVolumes.whiteNoiseVolume) { newValue in
                                print(newValue)
                                viewModel.whiteNoiseAudioManager.changeVolume(track: item.name,
                                                                 volume: newValue)
                            }
                        Text(String(Int(audioVolumes.whiteNoiseVolume * 100)))
                            .foregroundColor(.systemGrey1)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
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
    
    private func saveNewVolume() {
        guard let selectedMixedSound = viewModel.mixedSound else { return }
        guard let localBaseSound = viewModel.mixedSound?.baseSound,
              let localMelodySound = viewModel.mixedSound?.melodySound,
              let localWhiteNoiseSound = viewModel.mixedSound?.whiteNoiseSound else { return }
        
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
        
        let newMixedSound = MixedSound(id: selectedMixedSound.id,
                                       name: selectedMixedSound.name,
                                       baseSound: newBaseSound,
                                       melodySound: newMelodySound,
                                       whiteNoiseSound: newWhiteNoiseSound,
                                       imageName: selectedMixedSound.imageName)
        
        let index = userRepositoriesState.firstIndex { mixedSound in
            mixedSound.name == selectedMixedSound.name
        }
        
        userRepositories.remove(at: index ?? -1)
        userRepositories.insert(newMixedSound, at: index ?? -1)
        
        userRepositoriesState.remove(at: index ?? -1)
        userRepositoriesState.insert(newMixedSound, at: index ?? -1)
        
        let data = getEncodedData(data: userRepositories)
        UserDefaultsManager.shared.standard.set(data, forKey: UserDefaultsManager.shared.recipes)
    }
}

extension VolumeControlView {
    @ViewBuilder
    func UpperPartOfVolumeControlView() -> some View {
        VStack {
            Capsule()
                .frame(width: 72, height: 5)
                .foregroundColor(.systemGrey1)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 27, trailing: 0))
            HStack {
                Image(systemName: "waveform")
                    .foregroundColor(.relaxDimPurple)
                Text("MATERIAL VOLUME")
                    .foregroundColor(.white)
                    .font(.system(size: 17))
                Spacer()
            }
            .padding(.leading, 20)
        }
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
