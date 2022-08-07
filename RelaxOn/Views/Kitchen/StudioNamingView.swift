//
//  StudioNamingView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/07.
//

import SwiftUI

struct StudioNamingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    @Binding var textEntered: String
    var body: some View {
        ZStack{
            SelectedImageBackgroundView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues)
                .ignoresSafeArea()
                .blur(radius: 1)
            VStack{
                NamingBackButton()
                    .padding(.horizontal, 5)
                HStack {
                    Text("Please name this CD")
                        .frame(width: deviceFrame().exceptPaddingWidth / 2)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                    .lineLimit(2)
                    Spacer()
                }.padding(.horizontal, 10)
                VStack {
                    TextField("", text: $textEntered)
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .modifier(PlaceholderCustom(showPlaceHolder: textEntered.isEmpty, placeHolder: "Make your own CD"))

                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: deviceFrame().exceptPaddingWidth, height: 2)

                }
                Spacer().frame(width: deviceFrame().screenWidth, height: deviceFrame().screenHeight * 0.62, alignment: .center)
                SaveButton()
            }
        }.navigationBarHidden(true)
    }

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
        }.padding()
    }

    @ViewBuilder
    func SaveButton() -> some View {
        Button {
            print("hihihi")
        } label: {
            Text("SAVE")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.systemGrey1)
                .frame(width: deviceFrame().exceptPaddingWidth, height: deviceFrame().screenHeight * 0.06)
                .background(Color.relaxRealBlack)
        }
    }
}

struct PlaceholderCustom: ViewModifier {
    var showPlaceHolder: Bool
    var placeHolder: String

    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeHolder)
                    .padding(.horizontal, 15)
                    .foregroundColor(.systemGrey1)
                    .font(.system(size: 17, weight: .light))
            }
            content
                .foregroundColor(Color.white)
                .font(.system(size: 17, weight: .light))
        }
    }
}

