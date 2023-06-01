//
//  SoundSaveView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

/**
 이전 화면에서 커스텀 했던 음원에 이름과 이미지를 지정하여 파일로 저장하는 기능이 있는 View
 */
struct SoundSaveView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @FocusState private var isFocused: Bool
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State var soundSavedName: String = ""
    
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @State var originalSound: OriginalSound
    @State var audioVariation: AudioVariation
    @State var audioFilter: AudioFilter
    //@State var backgroundColor: String
    
    var body: some View {
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()
            VStack{
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color(.ChevronBack))
                            .frame(width: 30, height: 30)
                    }
                    
                    Spacer()
                    
                    Text(originalSound.category.displayName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(.Text))
                    
                    Spacer()
                    
                    Button {
                        print("[SoundSaveView - Button - 저장] viewModel.color : \(viewModel.color)")
                        let success = viewModel.save(with: originalSound, audioVariation: audioVariation, fileName: soundSavedName, color: viewModel.color)
                        
                        if success {
                            presentationMode.wrappedValue.dismiss()
                            presentationMode.wrappedValue.dismiss()
                            appState.moveToTab(.listen)
                        } else {
                            alertMessage = "동일한 파일명이 존재합니다.\n다른 파일이름으로 시도해보세요."
                            isShowingAlert = true
                        }
                        
                    } label: {
                        Text("저장")
                            .foregroundColor(Color(.PrimaryPurple))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                
                VStack {
                    TextField(originalSound.name, text: $soundSavedName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color(.Text))
                        .multilineTextAlignment(.center)
                        .keyboardType(.default)
                        .autocorrectionDisabled(true)
                        .focused($isFocused)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.TextFieldUnderLine))
                }
                .padding(.horizontal, 34)
                
                ZStack {
                    ZStack(alignment: .topTrailing) {
                        Image(originalSound.category.imageName)
                            .resizable()
                            .scaledToFit()
                            .background(Color(hex: viewModel.color))
                        Button {
                            let randomColor = CustomSoundImageBackgroundColor.allCases.randomElement()?.rawValue
                            viewModel.color = randomColor ?? originalSound.color
                            print("[SoundSaveView - Button - repeat] viewModel.color : \(viewModel.color)")
                        } label: {
                            Image("repeat")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color(hex: "1F1F1F"))
                                .padding(20)
                        }
                    }
                    .cornerRadius(15)
                    .padding(.vertical, 40)
                    .padding(.horizontal, 24)
                }
                Spacer()
            }
        }
        .onAppear {
            viewModel.stopSound()
            isFocused = true
            viewModel.color = originalSound.color
            print("[SoundSaveView - onAppear] viewModel.color : \(viewModel.color)")
        }
        .onDisappear {
            viewModel.stopSound()
            presentationMode.wrappedValue.dismiss()
        }
        .background(Color(.DefaultBackground))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("저장 실패"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .ignoresSafeArea(.keyboard)
    }
}


struct SoundSaveView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSaveView(originalSound: OriginalSound(name: "물방울", filter: .WaterDrop, category: .waterDrop), audioVariation: AudioVariation(), audioFilter: .WaterDrop)
    }
}
