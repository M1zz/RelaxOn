//
//  StudioView.swift
//  LullabyRecipe
//
//  Created by 김연호 on 2022/07/23.
//

import SwiftUI

struct StudioView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var select: Int = 0
    @State var showingAlert = false
    @State var selectedBaseSound: Sound = Sound(id: 0,
                                                        name: "",
                                                        soundType: .base,
                                                        audioVolume: 0.8,
                                                        imageName: "")
    @State var selectedMelodySound: Sound = Sound(id: 10,
                                                          name: "",
                                                          soundType: .melody,
                                                          audioVolume: 1.0,
                                                          imageName: "")
    @State var selectedNaturalSound: Sound = Sound(id: 20,
                                                           name: "",
                                                           soundType: .natural,
                                                           audioVolume: 0.4,
                                                           imageName: "")
    @State var userName: String = ""
    @State var textEntered = ""
    
    @Binding var selectedImageNames: (base: String, melody: String, natural: String)
    
    @State var opacityAnimationValues = [0.0, 0.0, 0.0]

    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()

    var items = ["BASE", "MELODY", "NATURAL"]
    var body: some View {
        VStack {
            SelectImage()
            Button {
                let newSound = MixedSound(id: userRepositories.count,
                                          name: textEntered,
                                          baseSound: selectedBaseSound,
                                          melodySound: selectedMelodySound,
                                          naturalSound: selectedNaturalSound,
                                          imageName: recipeRandomName.randomElement()!)
                userRepositories.append(newSound)
                
                let data = getEncodedData(data: userRepositories)
                UserDefaultsManager.shared.standard.set(data, forKey: UserDefaultsManager.shared.recipes)
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("blend")
                    .bold()
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           maxHeight: 50)
                    .background(ColorPalette.buttonBackground.color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            CustomSegmentControlView(items: items, selection: $select)
            switch select {
            case 1:
                SoundSelectView(sectionTitle: "Melody",
                                soundType: .melody)
            case 2:
                SoundSelectView(sectionTitle: "Natural Sound",
                                soundType: .natural)
            default:
                SoundSelectView(sectionTitle: "Base Sound",
                                soundType: .base)
            }
        }
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
    
    @ViewBuilder
    func SoundSelectView(sectionTitle: String,
                         soundType: SoundType) -> some View {
        VStack(spacing: 15) {

            HStack {
                Text("볼륨조절 컴포넌트")
            }

            ScrollView(.vertical,
                       showsIndicators: false) {
                HStack(spacing: 30) {
                    switch soundType {
                    case .base:
                            RadioButtonGroupView(selectedId: soundType.rawValue,
                                         items: baseSounds) { baseSelected in
                            selectedBaseSound = baseSelected
                            // play music

                            if selectedBaseSound.name == "Empty" {
                                baseAudioManager.stop()
                                
                                opacityAnimationValues[0] = 0.0
                            } else {
                                baseAudioManager.startPlayer(track: selectedBaseSound.name)
                                
                                selectedImageNames.base = selectedBaseSound.imageName
                                opacityAnimationValues[0] = 0.5
                            }


                        }
                    case .natural:
                            RadioButtonGroupView(selectedId: soundType.rawValue,
                                         items: naturalSounds) { naturalSounds in
                            selectedNaturalSound = naturalSounds


                            if selectedNaturalSound.name == "Empty" {
                                naturalAudioManager.stop()
                                
                                opacityAnimationValues[2] = 0.0
                            } else {
                                naturalAudioManager.startPlayer(track: selectedNaturalSound.name)
                                
                                selectedImageNames.natural = selectedNaturalSound.imageName
                                
                                opacityAnimationValues[2] = 0.5
                            }
                        }
                    case .melody:
                            RadioButtonGroupView(selectedId: soundType.rawValue,
                                         items: melodySounds) { melodySounds in
                            selectedMelodySound = melodySounds
                            
                            if selectedMelodySound.name == "Empty" {
                                melodyAudioManager.stop()
                                
                                opacityAnimationValues[1] = 0.0
                            } else {
                                melodyAudioManager.startPlayer(track: selectedMelodySound.name)
                                
                                selectedImageNames.melody = selectedMelodySound.imageName
                                
                                opacityAnimationValues[1] = 0.5
                                
                            }
                        }
                    }
                }
            }.padding(.horizontal, 15)
        }
    }
    
    @ViewBuilder
    func SelectImage() -> some View {
        ZStack {
            Rectangle()
                .DeviceFrame()
                .background(.gray)
            
            // Base
            illustImage(imageName: selectedImageNames.base, animateVar: opacityAnimationValues[0])
            
            // Melody
            illustImage(imageName: selectedImageNames.melody, animateVar: opacityAnimationValues[1])
            
            // Natural
            illustImage(imageName: selectedImageNames.natural, animateVar: opacityAnimationValues[2])
                
        }
    }
    
    @ViewBuilder
    func illustImage(imageName: String, animateVar: Double) -> some View {
        Image(imageName)
            .resizable()
            .DeviceFrame()
            .opacity(animateVar)
            .animation(.linear, value: animateVar)
    }
}

struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView(selectedImageNames: .constant((
                base: "",
                melody: "",
                natural: ""
            )))
    }
}
