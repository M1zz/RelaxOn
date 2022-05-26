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

var mixedAudioSources: [Sound] = []
var userRepositories: [MixedSound] = [MixedSound(id: 3,
                                                 name: "test4",
                                                 sounds: [Sound(id: 0, name: BaseAudioName.chineseGong.fileName, description: "chineseGong",imageName: "gong"),
                                                          Sound(id: 2, name: MelodyAudioName.lynx.fileName, description: "lynx",imageName: "r1"),
                                                          Sound(id: 6, name: NaturalAudioName.creekBabbling.fileName, description: "creekBabbling",imageName: "r3")
                                                                                                    ],
                                                 description: "test1",
                                                 imageName: "r1")]
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

enum SoundType: String {
    case base
    case melody
    case natural
}

struct Kitchen : View {
 
    @State private var showingAlert = false
    @State private var selectedBaseSound: Sound = Sound(id: 0, name: "", description: "", imageName: "")
    @State private var selectedMelodySound: Sound = Sound(id: 0, name: "", description: "", imageName: "")
    @State private var selectedNaturalSound: Sound = Sound(id: 0, name: "", description: "", imageName: "")
    @State var userName: String = ""
    
    @State private var textEntered = ""
    
    var body : some View {
        
        ZStack {
            ColorPalette.background.color.ignoresSafeArea()
            
            VStack(spacing: 15) {
                Profile()
                
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
            }
            .padding(.horizontal)
            CustomAlert(textEntered: $textEntered,
                        showingAlert: $showingAlert)
            .opacity(showingAlert ? 1 : 0)
        }
        
    }
    
    @ViewBuilder
    func Profile() -> some View {
        HStack(spacing: 12) {
            Image("logo")
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("Hi, \(userName)")
                .font(.body)
            
            Spacer()
        }
        .onAppear() {
            userName = UserDefaults.standard.string(forKey: "userName") ?? "Guest"
        }
    }

    
    @ViewBuilder
    func MixedAudioCreateButton() -> some View {
        Button {
            showingAlert = true
            mixedAudioSources = [selectedBaseSound, selectedMelodySound, selectedNaturalSound]
           

            self.textEntered = ""
        } label: {
            Text("Mix")
                .bold()
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       maxHeight: 50)
                .background(.gray)
                .foregroundColor(.black)
                .cornerRadius(25)
        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text("제목을 넣자"),
//                  message: Text("선택된 음악은 \(selectedBaseSound.name), \(selectedMelodySound.name), \(selectedNaturalSound.name) 입니다"),
//                  dismissButton: .default(Text("닫기")))
//        }
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
                        }
                    case .natural:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: naturalSounds) { naturalSounds in
                            print("naturalSounds is: \(naturalSounds)")
                            selectedNaturalSound = naturalSounds
                        }
                    case .melody:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: melodySounds) { melodySounds in
                            print("melodySounds is: \(melodySounds)")
                            selectedMelodySound = melodySounds
                        }
                    }
                }
            }
        }
    }
}

struct Kitchen_Previews: PreviewProvider {
    static var previews: some View {
        Kitchen()
    }
}
