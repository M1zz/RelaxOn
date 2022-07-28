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
    @State private var selectedBaseSound: Sound = Sound(id: 0,
                                                        name: "",
                                                        soundType: .base,
                                                        audioVolume: 0.8,
                                                        imageName: "")
    @State private var selectedMelodySound: Sound = Sound(id: 10,
                                                          name: "",
                                                          soundType: .melody,
                                                          audioVolume: 1.0,
                                                          imageName: "")
    @State private var selectedNaturalSound: Sound = Sound(id: 20,
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
    @State private var opacityAnimationValues = [0.0, 0.0, 0.0]

    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()

    private var items = ["BASE", "MELODY", "NATURAL"]
    init(){
        Theme.navigationBarColors(background: .white, titleColor: .black)
        UINavigationBar.appearance().standardAppearance.shadowColor = .clear
    }

    var body: some View {
        ZStack{
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
            .navigationBarItems(leading: Text("STUDIO").bold(), trailing: MixButton())
            .navigationBarHidden(false)
            .opacity(showingAlert ? 0.5 : 1)
            
            CustomAlertView(textEntered: $textEntered,
                        showingAlert: $showingAlert)
            .opacity(showingAlert ? 1 : 0)
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

    @ViewBuilder
    func MixButton() -> some View {
        Button {
            showingAlert = true

            baseSound = selectedBaseSound
            melodySound = selectedMelodySound
            naturalSound = selectedNaturalSound

            baseAudioManager.stop()
            melodyAudioManager.stop()
            naturalAudioManager.stop()

            self.textEntered = ""
        } label: {
            Text("Mix")
                .foregroundColor( ($selectedBaseSound.id == 0 && $selectedMelodySound.id == 10 && $selectedNaturalSound.id == 20) ? Color.gray : Color.black )
        }.disabled( ($selectedBaseSound.id == 0 && $selectedMelodySound.id == 10 && $selectedNaturalSound.id == 20) ? true : false )
    }
}


struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
