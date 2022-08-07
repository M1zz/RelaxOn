//
//  StudioView.swift
//  LullabyRecipe
//
//  Created by 김연호 on 2022/07/23.
//

import SwiftUI

struct StudioView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var select: Int = 0
    @State private var showingConfirm = false
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
    @State private var selectedWhiteNoiseSound: Sound = Sound(id: 20,
                                                           name: "",
                                                              soundType: .whiteNoise,
                                                           audioVolume: 0.4,
                                                           imageName: "")
    @State private var selectedImageNames: (base: String, melody: String, whiteNoise: String) = (
        base: "",
        melody: "",
        whiteNoise: ""
    )
    
    @State private var opacityAnimationValues = [0.0, 0.0, 0.0]

    @State private var textEntered = ""
    
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()

    private var items = ["BASE", "MELODY", "WHITE NOISE"]
    init(){
        Theme.navigationBarColors(background: .white, titleColor: .black)
        UINavigationBar.appearance().standardAppearance.shadowColor = .clear
    }

    var body: some View {
        ZStack{
            Color.relaxBlack.ignoresSafeArea()
            VStack {
                StudioBackButton()
                HStack{
                    Text("STUDIO")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                    MixButton()
                }.padding(.horizontal)
                SelectedImageVIew(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues)
                CustomSegmentControlView(items: items, selection: $select)
                switch select {
                case 1:
                    SoundSelectView(sectionTitle: "Melody",
                                    soundType: .melody)
                case 2:
                    SoundSelectView(sectionTitle: "WhiteNoise Sound",
                                    soundType: .whiteNoise)
                default:
                    SoundSelectView(sectionTitle: "Base Sound",
                                    soundType: .base)
                }
            }
            .navigationBarItems(leading: Text("STUDIO").bold())
            .navigationBarHidden(true)
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
                    case .whiteNoise:
                            RadioButtonGroupView(selectedId: soundType.rawValue,
                                         items: whiteNoiseSounds) { whiteNoiseSounds in
                            selectedWhiteNoiseSound = whiteNoiseSounds

                            if selectedWhiteNoiseSound.name == "Empty" {
                                naturalAudioManager.stop()
                                
                                opacityAnimationValues[2] = 0.0
                            } else {
                                naturalAudioManager.startPlayer(track: selectedWhiteNoiseSound.name)
                                
                                selectedImageNames.whiteNoise = selectedWhiteNoiseSound.imageName
                                
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
    func MixButton() -> some View {
        NavigationLink(destination: StudioNamingView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues, textEntered: $textEntered)) {
            Text("Mix")
                .font(.system(size: 24, weight: .regular))
                .foregroundColor( ($selectedBaseSound.id == 0 && $selectedMelodySound.id == 10 && $selectedWhiteNoiseSound.id == 20) ? Color.gray : Color.relaxDimPurple )
        }.disabled( ($selectedBaseSound.id == 0 && $selectedMelodySound.id == 10 && $selectedWhiteNoiseSound.id == 20) ? true : false )
            .simultaneousGesture(TapGesture().onEnded { _ in
                baseSound = selectedBaseSound
                melodySound = selectedMelodySound
                whiteNoiseSound = selectedWhiteNoiseSound

                baseAudioManager.stop()
                melodyAudioManager.stop()
                naturalAudioManager.stop()
                self.textEntered = ""
            })
    }

    @ViewBuilder
    func StudioBackButton() -> some View {
        HStack{
            Button(action: {
                showingConfirm = true
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.relaxDimPurple)
            })
            .confirmationDialog("Leave Studio", isPresented: $showingConfirm) {
                Button("Leave Studio", role: .destructive){
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Cancle", role: .cancel){}
            } message: {
                Text("나가면 사라집니다...")
            }
            Text("CD LIBRARY")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(.relaxDimPurple)
            Spacer()
        }.padding()
    }
}


struct StudioView_Previews: PreviewProvider {
    static var previews: some View {
        StudioView()
    }
}
