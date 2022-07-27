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
    @State private var selectedMelodySound: Sound = Sound(id: 0,
                                                          name: "",
                                                          soundType: .melody,
                                                          audioVolume: 1.0,
                                                          imageName: "")
    @State private var selectedNaturalSound: Sound = Sound(id: 0,
                                                           name: "",
                                                           soundType: .natural,
                                                           audioVolume: 0.4,
                                                           imageName: "")
    @State var userName: String = ""
    @State private var textEntered = ""

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
        }
        CustomAlert(textEntered: $textEntered,
                    showingAlert: $showingAlert,
                    selected: $selected)
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
                            } else {
                                baseAudioManager.startPlayer(track: selectedBaseSound.name)
                            }


                        }
                    case .natural:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: naturalSounds) { naturalSounds in
                            selectedNaturalSound = naturalSounds


                            if selectedNaturalSound.name == "Empty" {
                                naturalAudioManager.stop()
                            } else {
                                naturalAudioManager.startPlayer(track: selectedNaturalSound.name)
                            }
                        }
                    case .melody:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: melodySounds) { melodySounds in
                            selectedMelodySound = melodySounds

                            if selectedMelodySound.name == "Empty" {
                                melodyAudioManager.stop()
                            } else {
                                melodyAudioManager.startPlayer(track: selectedMelodySound.name)
                            }
                        }
                    }
                }
            }.padding(.horizontal, 15)
        }
    }

    @ViewBuilder
    func SelectImage() -> some View {
        Rectangle()
            .frame(width: deviceFrame().exceptPaddingWidth, height: deviceFrame().exceptPaddingWidth, alignment: .center)
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
                .foregroundColor( $selectedBaseSound.id == 0 && $selectedMelodySound.id == 0 && $selectedNaturalSound.id == 0 ? Color.gray : Color.black )
        }

    }
}


struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
