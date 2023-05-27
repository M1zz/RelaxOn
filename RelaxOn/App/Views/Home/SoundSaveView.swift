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
    @State var backgroundColor: Color = .white
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .padding()
                }
                
                Spacer()
                
                Button {
                    viewModel.save(with: originalSound, audioVariation: audioVariation, fileName: soundSavedName, color: backgroundColor)
                } label: {
                    Text("저장")
                        .padding()
                }
            }

            TextField(originalSound.name, text: $soundSavedName)
                .multilineTextAlignment(.center)
                .keyboardType(.default)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .font(.title)
                .underline(true)
            
            GeometryReader { geometry in
                ZStack(alignment: .topTrailing){
                    Image(originalSound.category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .cornerRadius(15)
                        .padding()
                        .background(backgroundColor) // setting the background color
                    Button {
                        let randomColor = CustomSoundImageBackgroundColor.allCases.randomElement() ?? .TitanWhite
                        backgroundColor = Color(randomColor)
                    } label: {
                        Image("repeat-light")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.black)
                            .padding(30)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .padding(.horizontal, 30)
            }
            
            Spacer()

        }
        .onAppear {
            isFocused = true
            backgroundColor = Color(hex: originalSound.defaultColor)
        }
        .background(Color.white)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .ignoresSafeArea(.keyboard)
    }
}


struct SoundSaveView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSaveView(originalSound: OriginalSound(name: "물소리", filter: .waterDrop, category: .waterDrop, defaultColor: ""), audioVariation: AudioVariation())
    }
}
