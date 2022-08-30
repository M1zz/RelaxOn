//
//  MusicRenameView.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/08/06.
//

import SwiftUI

struct MusicRenameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: MusicViewModel
    @State private var textEntered: String = ""
    @Binding var userRepositoriesState: [MixedSound]
    var mixedSound: MixedSound
    
    var body: some View {
        ZStack {
            CDCoverView()
                .ignoresSafeArea()
            
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
                        .modifier(RenamePlaceholderCustom(showPlaceHolder: textEntered.isEmpty, placeHolder: "Make your own CD"))
                        .keyboardType(.alphabet)
                        .multilineTextAlignment(.leading)
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
    
    @ViewBuilder
    func CDCoverView() -> some View {
        ZStack {
            Image(mixedSound.baseSound?.fileName ?? "")
                .resizable()
                .opacity(0.5)
            //                .frame(width: .infinity, height: .infinity)
            Image(mixedSound.melodySound?.fileName ?? "")
                .resizable()
                .opacity(0.5)
            //                .frame(width: .infinity, height: .infinity)
            Image(mixedSound.whiteNoiseSound?.fileName ?? "")
                .resizable()
                .opacity(0.5)
            //                .frame(width: .infinity, height: .infinity)
        }
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
            let renamedMixedSound = MixedSound(name: textEntered,
                                               baseSound: mixedSound.baseSound,
                                               melodySound: mixedSound.melodySound,
                                               whiteNoiseSound: mixedSound.whiteNoiseSound,
                                               fileName: recipeRandomName.randomElement()!)
            
            let index = userRepositoriesState.firstIndex { element in
                element.name == mixedSound.name
            }
            
            viewModel.mixedSound = renamedMixedSound
            userRepositories.remove(at: index ?? -1)
            userRepositories.insert(renamedMixedSound, at: index ?? -1)
            userRepositoriesState.remove(at: index ?? -1)
            userRepositoriesState.insert(renamedMixedSound, at: index ?? -1)
            
            let data = getEncodedData(data: userRepositories)
            UserDefaultsManager.shared.recipes = data
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct RenamePlaceholderCustom: ViewModifier {
    var showPlaceHolder: Bool
    var placeHolder: String
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeHolder)
                    .foregroundColor(.systemGrey1)
                    .font(.system(size: 17, weight: .light))
            }
            content
                .foregroundColor(Color.white)
                .font(.system(size: 17, weight: .light))
        }
    }
}
