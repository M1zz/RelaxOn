//
//  NewOnboardingView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/08.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: - State Properties
    @State var select: Int = 0
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
    @State var selectedWhiteNoiseSound: Sound = Sound(id: 20,
                                                      name: "",
                                                      soundType: .whiteNoise,
                                                      audioVolume: 0.4,
                                                      imageName: "")
    @State var selectedImageNames: (base: String, melody: String, whiteNoise: String) = (
        base: "",
        melody: "",
        whiteNoise: ""
    )

    @State var opacityAnimationValues = [0.0, 0.0, 0.0]
    @State var textEntered = ""
    @State var stepBarWidth = deviceFrame.screenWidth * 0.33
    @Binding var showOnboarding: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: - General Properties
    let baseAudioManager = AudioManager()
    let melodyAudioManager = AudioManager()
    let naturalAudioManager = AudioManager()

    var items = ["BASE", "MELODY", "WHITE NOISE"]

    // MARK: - Life Cycles
    var body: some View {
        NavigationView{
            ZStack {
                Color.relaxBlack.ignoresSafeArea()

                VStack {
                    Spacer()
                    HStack{
                        OnboardingStepBar()
                        Spacer()
                    }

                    HStack {
                        HStack {
                            VStack(alignment: .leading) {

                                HStack {
                                    let text: String = "Please select \n\(items[select])"
                                    Text(LocalizedStringKey(text))
                                        .font(.system(size: 28, weight: .medium))
                                        .foregroundColor(.white)
                                    Spacer()
                                }.fixedSize()
                            }

                            Spacer()
                        }.padding()

                        Spacer()

                        MixButton()
                            .padding()
                    }.padding(.horizontal)

                    SelectedImageView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues)
                    CustomSegmentControlView(items: items, selection: $select)

                    switch select {
                    case 1:
                        SoundSelectView(sectionTitle: "Melody",
                                        soundType: .melody)
                        .onAppear() {
                            withAnimation(.default) {
                                stepBarWidth = deviceFrame.screenWidth * 0.66
                            }
                        }

                    case 2:
                        SoundSelectView(sectionTitle: "WhiteNoise Sound",
                                        soundType: .whiteNoise)
                        .onAppear() {
                            withAnimation(.default) {
                                stepBarWidth = deviceFrame.screenWidth * 0.95
                            }
                        }

                    default:
                        SoundSelectView(sectionTitle: "Base Sound",
                                        soundType: .base)
                        .onAppear() {
                            withAnimation(.default) {
                                stepBarWidth = deviceFrame.screenWidth * 0.33
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

// MARK: - ViewBuilder
extension OnboardingView {
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
        NavigationLink(destination: OnboadingNamingView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues, textEntered: $textEntered, showOnboarding: $showOnboarding)) {
            Text("Mix")
                .font(.system(size: 24, weight: .regular))
                .foregroundColor( ($selectedBaseSound.id == 0 || $selectedMelodySound.id == 10 || $selectedWhiteNoiseSound.id == 20) ? Color.gray : Color.relaxDimPurple )
        }
        .opacity(($selectedBaseSound.id == 0 || $selectedMelodySound.id == 10 || $selectedWhiteNoiseSound.id == 20) ? 0 : 1)
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
    func OnboardingStepBar() -> some View {
        Rectangle()
            .frame(width: stepBarWidth, height: 3)
            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.relaxNightBlue, Color.relaxLavender]), startPoint: .leading, endPoint: .trailing))
    }
}
