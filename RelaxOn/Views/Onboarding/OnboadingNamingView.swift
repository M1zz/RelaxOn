//
//  OnboadingNamingView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/08.
//

import SwiftUI

struct OnboadingNamingView: View {
    // MARK: - State Properties
    @State var isNamingNavigate: Bool = false
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    @Binding var textEntered: String
    @Binding var showOnboarding: Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    // MARK: - Life Cycles
    var body: some View {
        ZStack {
            SelectedImageBackgroundView(selectedImageNames: $selectedImageNames,
                                        opacityAnimationValues: $opacityAnimationValues)
                .blur(radius: 5)
            
            VStack {
                HStack {
                    Text("Please name this CD")
                        .frame(width: deviceFrame.exceptPaddingWidth / 2)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Spacer()
                }.padding()
                
                VStack {
                    TextField("", text: $textEntered)
                        .foregroundColor(.white)
                        .modifier(PlaceholderCustom(showPlaceHolder: textEntered.isEmpty, placeHolder: "Make your own CD"))
                        .keyboardType(.alphabet)
                        .padding(.horizontal, 15)
                    
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: deviceFrame.exceptPaddingWidth, height: 2)
                }
                Spacer()

                SaveButton()
                
            }
        }.navigationBarHidden(true)
    }
}

// MARK: - ViewBuilder
extension OnboadingNamingView {
    @ViewBuilder
    func SaveButton() -> some View {
        NavigationLink(isActive: $isNamingNavigate) {
            OnboardingFinishView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues, textEntered: $textEntered, showOnboarding: $showOnboarding)
        } label: {}
        
        Button {
            let newSound = MixedSound(name: textEntered,
                                      baseSound: baseSound,
                                      melodySound: melodySound,
                                      whiteNoiseSound: whiteNoiseSound,
                                      fileName: recipeRandomName.randomElement()!)
            userRepositories.append(newSound)
            
            let data = getEncodedData(data: userRepositories)
            UserDefaultsManager.shared.recipes = data
            isNamingNavigate = true
        } label: {
            Text("SAVE")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
                .frame(width: deviceFrame.exceptPaddingWidth, height: deviceFrame.screenHeight * 0.07)
                .cornerRadius(10)
                .background(.black)
        }
        .opacity(textEntered.isEmpty ? 0.5 : 1)
        .padding()
    }

}
