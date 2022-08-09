//
//  OnboadingNamingView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/08.
//

import SwiftUI

struct OnboadingNamingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    @Binding var textEntered: String
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {

            SelectedImageBackgroundView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues)
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
    func SaveButton() -> some View {
//        NavigationLink(isActive: <#T##Binding<Bool>#>) {
//            <#code#>
//        } label: {
//            <#code#>
//        }

        NavigationLink {
            OnboardingFinishView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues, showOnboarding: $showOnboarding)
        } label: {
            Text("SAVE")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .light))
                .frame(width: deviceFrame.exceptPaddingWidth, height: deviceFrame.screenHeight * 0.07)
        }
        .background(.black)
        .opacity(textEntered.isEmpty ? 0.5 : 1)
        .simultaneousGesture(TapGesture().onEnded { _ in
            let newSound = MixedSound(id: userRepositories.count,
                                      name: textEntered,
                                      baseSound: baseSound,
                                      melodySound: melodySound,
                                      whiteNoiseSound: whiteNoiseSound,
                                      imageName: recipeRandomName.randomElement()!)
            userRepositories.append(newSound)

            let data = getEncodedData(data: userRepositories)
            UserDefaultsManager.shared.standard.set(data, forKey: UserDefaultsManager.shared.recipes)
            print("SaveButtonWork")
        })
//        .onTapGesture {
//            let newSound = MixedSound(id: userRepositories.count,
//                                      name: textEntered,
//                                      baseSound: baseSound,
//                                      melodySound: melodySound,
//                                      whiteNoiseSound: whiteNoiseSound,
//                                      imageName: recipeRandomName.randomElement()!)
//            userRepositories.append(newSound)
//
//            let data = getEncodedData(data: userRepositories)
//            UserDefaultsManager.shared.standard.set(data, forKey: UserDefaultsManager.shared.recipes)
//            print("SaveButtonWork")
//        }
        .padding()
    }
}
