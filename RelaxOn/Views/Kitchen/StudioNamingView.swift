//
//  StudioNamingView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/07.
//

import SwiftUI

struct StudioNamingView: View {
    // MARK: - State Properties
    @Binding var shouldPoptoRootView: Bool
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    @Binding var textEntered: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // MARK: - Life Cycles
    var body: some View {
        ZStack {

            SelectedImageBackgroundView(selectedImageNames: $selectedImageNames,
                                        opacityAnimationValues: $opacityAnimationValues)
                .blur(radius: 5)

            VStack {
                HStack {
                    NamingBackButton()
                        .padding(.horizontal, 15)
                    Spacer()
                }

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
extension StudioNamingView {
    @ViewBuilder
    func NamingBackButton() -> some View {
        HStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.white)
            })

            Text("Studio")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
            Spacer()
        }
    }

    @ViewBuilder
    func SaveButton() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.relaxRealBlack)

            Text("SAVE")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .light))
        }
        .frame(width: deviceFrame.exceptPaddingWidth, height: deviceFrame.screenHeight * 0.07)
        .opacity(textEntered.isEmpty ? 0.5 : 1)
        .padding()
        .onTapGesture {
            let newSound = MixedSound(name: textEntered,
                                      baseSound: baseSound,
                                      melodySound: melodySound,
                                      whiteNoiseSound: whiteNoiseSound,
                                      fileName: recipeRandomName.randomElement()!)
            userRepositories.append(newSound)

            let data = getEncodedData(data: userRepositories)
            UserDefaultsManager.shared.recipes = data
            self.shouldPoptoRootView = false
        }
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
