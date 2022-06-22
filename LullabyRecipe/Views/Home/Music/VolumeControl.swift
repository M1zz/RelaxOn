//
//  VolumeControl.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/29.
//

import SwiftUI

struct VolumeControl: View {
    
    @Binding var showVolumeControl: Bool
    @State var baseVolume: Float
    @State var melodyVolume: Float
    @State var naturalVolume: Float
    
    let data: MixedSound
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()
    @State var hasShowAlert: Bool = false
    
    // 코드 추가
    // MusicView와 연결
    @Binding var newData: MixedSound
    
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
                        // 코드 수정
                        // newData로 변경
                        let localBaseSound = newData.baseSound
                        let localMelodySound = newData.melodySound
                        let localNaturalSound = newData.naturalSound
                        
                        // Slider에 따라 볼륨이 잘 변경됐는지 확인
                        print("볼륨 확인")
                        print(baseVolume, melodyVolume, naturalVolume)
                        
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
                        
                        // 코드 수정
                        // newData로 변경
                        let newMixedSound = MixedSound(id: newData.id,
                                                       name: newData.name,
                                                       baseSound: newBaseSound,
                                                       melodySound: newMelodySound,
                                                       naturalSound: newNaturalSound,
                                                       imageName: newData.imageName)
                        // 코드 추가
                        // newData에 바뀐 볼륨 적용
                        newData.changeVolume(newMixedSound: newMixedSound)
                        
                        // 근데 여기엔 바뀌지 않음
                        print(newData)
                        
                        print("save 버튼 누를 때 newData")
                        // newMixedSound는 잘 변경됨
                        print(newMixedSound)
                        
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
                
                // 코드 수정
                // newData로 변경
                if let baseSound = newData.baseSound {
                    SoundControlSlider(item: baseSound)
                }
                
                if let melodySound = newData.melodySound {
                    SoundControlSlider(item: melodySound)
                }
                
                if let naturalSound = newData.naturalSound {
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
