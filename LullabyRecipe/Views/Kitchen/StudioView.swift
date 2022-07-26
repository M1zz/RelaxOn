//
//  StudioView.swift
//  LullabyRecipe
//
//  Created by 김연호 on 2022/07/23.
//

import SwiftUI

struct StudioView: View {
    @State private var select: Int = 0
    @State private var showingAlert = false
    @State private var selectedBaseSound: Sound = Sound(id: 11,
                                                        name: "",
                                                        soundType: .base,
                                                        audioVolume: 0.8,
                                                        imageName: "")
    @State private var selectedMelodySound: Sound = Sound(id: 12,
                                                          name: "",
                                                          soundType: .melody,
                                                          audioVolume: 1.0,
                                                          imageName: "")
    @State private var selectedNaturalSound: Sound = Sound(id: 13,
                                                           name: "",
                                                           soundType: .natural,
                                                           audioVolume: 0.4,
                                                           imageName: "")
    @State var userName: String = ""
    @State private var textEntered = ""
    
    @State private var selectedImageNames = (
        base: "",
        melody: "",
        natural: ""
    )
    @State var animateVars = [0.0, 0.0, 0.0]

    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()

    private var items = ["BASE", "MELODY", "NATURAL"]
    var body: some View {
        VStack {
            SelectImage()
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
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: baseSounds) { baseSelected in
                            selectedBaseSound = baseSelected
                            // play music

                            if selectedBaseSound.name == "Empty" {
                                baseAudioManager.stop()
                                
                                animateVars[0] = 0.0
                            } else {
                                baseAudioManager.startPlayer(track: selectedBaseSound.name)
                                
                                selectedImageNames.base = selectedBaseSound.imageName
                                animateVars[0] = 0.5
                            }


                        }
                    case .natural:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: naturalSounds) { naturalSounds in
                            selectedNaturalSound = naturalSounds


                            if selectedNaturalSound.name == "Empty" {
                                naturalAudioManager.stop()
                                
                                animateVars[2] = 0.0
                            } else {
                                naturalAudioManager.startPlayer(track: selectedNaturalSound.name)
                                
                                selectedImageNames.natural = selectedNaturalSound.imageName
                                
                                animateVars[2] = 0.5
                            }
                        }
                    case .melody:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: melodySounds) { melodySounds in
                            selectedMelodySound = melodySounds
                            
                            if selectedMelodySound.name == "Empty" {
                                melodyAudioManager.stop()
                                
                                animateVars[1] = 0.0
                            } else {
                                melodyAudioManager.startPlayer(track: selectedMelodySound.name)
                                
                                selectedImageNames.melody = selectedMelodySound.imageName
                                
                                animateVars[1] = 0.5
                                
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
            illustImage(imageName: selectedImageNames.base, animateVar: animateVars[0])
            
            // Melody
            illustImage(imageName: selectedImageNames.melody, animateVar: animateVars[1])
            
            // Natural
            illustImage(imageName: selectedImageNames.natural, animateVar: animateVars[2])
                
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
        StudioView()
    }
}
