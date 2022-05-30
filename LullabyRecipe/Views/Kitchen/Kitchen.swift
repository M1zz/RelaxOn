//
//  Kitchen.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI

var categories = ["Natural",
                  "Mind Peace",
                  "Focus",
                  "Deep Sleep",
                  "Lullaby"]



enum SoundType: String, Codable {
    case base
    case melody
    case natural
}

struct Kitchen : View {
 
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
    @Binding var selected: SelectedType
    
    @State private var textEntered = ""
    
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()
    
    var body : some View {
        
        ZStack {
            ColorPalette.background.color.ignoresSafeArea()
            
            VStack(spacing: 15) {
                //Profile()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 15) {
                        SoundSelectView(sectionTitle: "Base Sound",
                                        soundType: .base)
                        
                        SoundSelectView(sectionTitle: "Melody",
                                        soundType: .melody)
                        
                        SoundSelectView(sectionTitle: "Natural Sound",
                                        soundType: .natural)
                    }
                }
                
                MixedAudioCreateButton()
                    .padding(.bottom, 20)
                    .padding(.top, 20)
            }
            .padding(.horizontal)
            CustomAlert(textEntered: $textEntered,
                        showingAlert: $showingAlert,
                        selected: $selected)
            .opacity(showingAlert ? 1 : 0)
        }
        
    }
    
    @ViewBuilder
    func Profile() -> some View {
        HStack(spacing: 12) {
            WhiteTitleText(title: "Hi, \(userName)")
            Spacer()
        }
        .padding(.vertical, 20)
        .onAppear() {
            userName = UserDefaults.standard.string(forKey: "userName") ?? "Guest"
        }
    }

    
    @ViewBuilder
    func MixedAudioCreateButton() -> some View {
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
            Text("Blend")
                .bold()
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       maxHeight: 50)
                .background(ColorPalette.buttonBackground.color)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }

    @ViewBuilder
    func SoundSelectView(sectionTitle: String,
                        soundType: SoundType) -> some View {
        
        VStack(spacing: 15) {
            
            HStack {
                WhiteTitleText(title: sectionTitle)
                
                Spacer()
                
            }.padding(.vertical, 15)
            
            ScrollView(.horizontal,
                       showsIndicators: false) {
                HStack(spacing: 15) {
                    
                    switch soundType {
                    case .base:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: baseSounds) { baseSelected in
                            print("baseSelected is: \(baseSelected)")
                            selectedBaseSound = baseSelected
                            // play music
                            baseAudioManager.startPlayer(track: baseSelected.name)
                            
                        }
                    case .natural:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: naturalSounds) { naturalSounds in
                            print("naturalSounds is: \(naturalSounds)")
                            selectedNaturalSound = naturalSounds
                            naturalAudioManager.startPlayer(track: naturalSounds.name)
                        }
                    case .melody:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: melodySounds) { melodySounds in
                            print("melodySounds is: \(melodySounds)")
                            selectedMelodySound = melodySounds
                            melodyAudioManager.startPlayer(track: melodySounds.name)
                        }
                    }
                }
            }
        }
    }
}

struct Kitchen_Previews: PreviewProvider {
    static var previews: some View {
        Kitchen(selected: .constant(.kitchen))
    }
}


//[MixedSound(id: 0,
//                                                 name: "test",
//                                                 sounds: [Sound(id: 0, name: BaseAudioName.chineseGong.fileName, description: "chineseGong",imageName: "gong"),
//                                                          Sound(id: 2, name: MelodyAudioName.lynx.fileName, description: "lynx",imageName: "r1"),
//                                                          Sound(id: 6, name: NaturalAudioName.creekBabbling.fileName, description: "creekBabbling",imageName: "r3")
//                                                         ],
//                                                 description: "test1",
//                                                 imageName: "r1"),
//
//                                      MixedSound(id: 1,
//                                                                      name: "test2",
//                                                                      sounds: [Sound(id: 0, name: BaseAudioName.chineseGong.fileName, description: "chineseGong",imageName: "gong"),
//                                                                               Sound(id: 2, name: MelodyAudioName.lynx.fileName, description: "lynx",imageName: "r1"),
//                                                                               Sound(id: 6, name: NaturalAudioName.creekBabbling.fileName, description: "creekBabbling",imageName: "r3")
//                                                                              ],
//                                                                      description: "test1",
//                                                                      imageName: "r1"),
//
//                                      MixedSound(id: 2,
//                                                                      name: "test3",
//                                                                      sounds: [Sound(id: 0, name: BaseAudioName.chineseGong.fileName, description: "chineseGong",imageName: "gong"),
//                                                                               Sound(id: 2, name: MelodyAudioName.lynx.fileName, description: "lynx",imageName: "r1"),
//                                                                               Sound(id: 6, name: NaturalAudioName.creekBabbling.fileName, description: "creekBabbling",imageName: "r3")
//                                                                              ],
//                                                                      description: "test1",
//                                                                      imageName: "r1"),
//
//                                      MixedSound(id: 3,
//                                                                      name: "test4",
//                                                                      sounds: [Sound(id: 0, name: BaseAudioName.chineseGong.fileName, description: "chineseGong",imageName: "gong"),
//                                                                               Sound(id: 2, name: MelodyAudioName.lynx.fileName, description: "lynx",imageName: "r1"),
//                                                                               Sound(id: 6, name: NaturalAudioName.creekBabbling.fileName, description: "creekBabbling",imageName: "r3")
//                                                                              ],
//                                                                      description: "test1",
//                                                                      imageName: "r1")]
