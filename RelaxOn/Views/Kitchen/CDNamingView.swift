//
//  CDNamingView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/07.
//

import SwiftUI

struct CDNamingView: View {
    // MARK: - State Properties
    @State var goToOnboardingFinishView: Bool = false
    @State var soundName = ""
    @Binding var goToPreviousView: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var mixedSound: MixedSound
    
    var musicModelDelegate: MusicViewDelegate?
    var previousView: PreviousView = .music
    
    // MARK: - Enumeration Condition
    enum PreviousView {
        case onboarding
        case studio
        case music
    }
    
    // MARK: - Life Cycles
    var body: some View {
        ZStack {
            
            CDCoverImageView(selectedImageNames: mixedSound.getImageName())
                .toBlurBackground()
            
            VStack {
                HStack {
                    NamingBackButton()
                        .padding(.horizontal)
                    Spacer()
                }

                HStack {
                    Text("Please name this CD")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, deviceFrame.screenHeight * 0.04)

                VStack(alignment: .leading) {
                    TextField("", text: $soundName)
                        .foregroundColor(.white)
                        .modifier(PlaceholderCustom(showPlaceHolder: soundName.isEmpty, placeHolder: "Make your own CD"))
                        .keyboardType(.alphabet)
                        .padding(.horizontal)
                        .multilineTextAlignment(.leading)

                    Rectangle()
                        .foregroundColor(.white)
                        .frame(height: 4)
                        .padding(.horizontal)
                }
                Spacer()
                
                switch previousView {
                case .music:
                    RenameCDSaveButton()
                case .studio:
                    NewCDSaveButton()
                case .onboarding:
                    OnboardingSaveButton()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - ViewBuilder
extension CDNamingView {
    @ViewBuilder
    func NamingBackButton() -> some View {
        HStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                    
                    Text("Studio")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                }
            })
            Spacer()
        }
    }

    @ViewBuilder
    func SaveButton() -> some View {
        Text("SAVE")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .light))
            .frame(width: deviceFrame.exceptPaddingWidth,
                   height: deviceFrame.screenHeight * 0.07)
            .background {
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(.relaxRealBlack)
            }
            .padding()
    }
    
    @ViewBuilder
    func OnboardingSaveButton() -> some View {
        NavigationLink(isActive: $goToOnboardingFinishView) {
            OnboardingFinishView(showOnboarding: $goToPreviousView, mixedSound: mixedSound)
        } label: {
            SaveButton()
                .onTapGesture {
                    mixedSound = MixedSound(name: soundName,
                                              baseSound: baseSound,
                                              melodySound: melodySound,
                                              whiteNoiseSound: whiteNoiseSound,
                                              fileName: recipeRandomName.randomElement()!)
                    goToOnboardingFinishView = true
                }
        }
        .opacity(soundName.isEmpty ? 0.5 : 1)
        .disabled(soundName.isEmpty)
    }
    
    @ViewBuilder
    func NewCDSaveButton() -> some View {
        Button {
            let newSound = MixedSound(name: self.soundName,
                                      baseSound: mixedSound.baseSound,
                                      melodySound: mixedSound.melodySound,
                                      whiteNoiseSound: mixedSound.whiteNoiseSound,
                                      fileName: recipeRandomName.randomElement()!)
            
            userRepositories.append(newSound)
            let data = getEncodedData(data: userRepositories)
            UserDefaultsManager.shared.recipes = data
            self.goToPreviousView = false
        } label: {
            SaveButton()
        }
        .opacity(soundName.isEmpty ? 0.5 : 1)
        .disabled(soundName.isEmpty)
    }
    
    @ViewBuilder
    func RenameCDSaveButton() -> some View {
        Button {
            let newSound = MixedSound(id: mixedSound.id,
                                      name: self.soundName,
                                      baseSound: mixedSound.baseSound,
                                      melodySound: mixedSound.melodySound,
                                      whiteNoiseSound: mixedSound.whiteNoiseSound,
                                      fileName: recipeRandomName.randomElement()!)
            musicModelDelegate?.renameMusic(renamedMixedSound: newSound)
            presentationMode.wrappedValue.dismiss()
        } label: {
            SaveButton()
        }
        .opacity(soundName.isEmpty ? 0.5 : 1)
        .disabled(soundName.isEmpty)
    }
}

struct PlaceholderCustom: ViewModifier {
    var showPlaceHolder: Bool
    var placeHolder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(LocalizedStringKey(placeHolder))
                    .foregroundColor(.systemGrey1)
                    .font(.system(size: 17, weight: .light))
            }
            content
                .foregroundColor(Color.white)
                .font(.system(size: 17, weight: .light))
        }
    }
}
