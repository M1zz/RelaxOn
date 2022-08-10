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
    @Binding var audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float)
    @Binding var userRepositoriesState: [MixedSound] {
        didSet {
            print("last24", userRepositoriesState.last?.baseSound?.audioVolume)
        }
    }
    
    let data: MixedSound
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()
    @State var hasShowAlert: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                UpperPartOfVolumeControlView()
                    .padding(.bottom, UIScreen.main.bounds.height * 0.05)
                
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
                                baseAudioManager.changeVolume(track: item.name,
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
                                melodyAudioManager.changeVolume(track: item.name,
                                                                volume: newValue)
                            }
                        Text(String(Int(audioVolumes.melodyVolume * 100)))
                            .foregroundColor(.systemGrey1)
                    case .natural:
                        Slider(value: $audioVolumes.naturalVolume, in: 0...1) { editing in
                            if !editing {
                                saveNewVolume()
                            }
                        }
                            .background(.black)
                            .cornerRadius(4)
                            .accentColor(.white)
                            .padding(.horizontal, 20)
                            .onChange(of: audioVolumes.naturalVolume) { newValue in
                                print(newValue)
                                naturalAudioManager.changeVolume(track: item.name,
                                                                 volume: newValue)
                            }
                        Text(String(Int(audioVolumes.naturalVolume * 100)))
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
        guard let mixedSound = viewModel.mixedSound else { return }
        guard let localBaseSound = viewModel.mixedSound?.baseSound,
              let localMelodySound = viewModel.mixedSound?.melodySound,
              let localNaturalSound = viewModel.mixedSound?.naturalSound else { return }
        
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
        
        let newNaturalSound = Sound(id: localNaturalSound.id,
                                    name: localNaturalSound.name,
                                    soundType: localNaturalSound.soundType,
                                    audioVolume: audioVolumes.naturalVolume,
                                    imageName: localNaturalSound.imageName)
        
        let newMixedSound = MixedSound(id: mixedSound.id,
                                       name: mixedSound.name,
                                       baseSound: newBaseSound,
                                       melodySound: newMelodySound,
                                       naturalSound: newNaturalSound,
                                       imageName: mixedSound.imageName)
        
//        userRepositories.remove(at: mixedSound.id)
//        userRepositories.insert(newMixedSound, at: mixedSound.id)
//        userRepositoriesState = userRepositories
        #warning("DAKE 화이팅")
        
        userRepositoriesState.remove(at: mixedSound.id)
        userRepositoriesState.insert(newMixedSound, at: mixedSound.id)
        
        print("last22", userRepositories.last?.baseSound?.audioVolume)
        print("last25", userRepositoriesState.last?.baseSound?.audioVolume)
        
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
