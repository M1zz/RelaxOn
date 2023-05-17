//
//  SoundSaveView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundSaveView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = MixedSoundsViewModel()
    @EnvironmentObject var appState: AppState
    @FocusState private var isFocused: Bool
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State var soundSavedName: String = ""
    @State var mixedSound: MixedSound
    
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
                    isFocused = false
                    let newMixedSound = MixedSound(name: soundSavedName, imageName: mixedSound.imageName)
                    viewModel.saveMixedSound(newMixedSound) { result in
                        switch result {
                        case .success:
                            appState.moveToTab(.listen)
                            presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            switch error {
                            case .fileSaveFailed:
                                isShowingAlert = true
                                alertMessage = "저장에 실패했습니다."
                            case .invalidData:
                                isShowingAlert = true
                                alertMessage = "잘못된 데이터입니다."
                            case .decodingFailed:
                                isShowingAlert = true
                                alertMessage = "디코딩에 실패했습니다."
                            }
                        }
                    }
                } label: {
                    Text("저장")
                        .padding()
                }
                
            }
            
                TextField(mixedSound.name, text: $soundSavedName)
                    .multilineTextAlignment(.center)
                    .keyboardType(.default)
                    .autocorrectionDisabled(true)
                    .focused($isFocused)
                    .font(.title)
                    .underline(true)
                
                ZStack(alignment: .topTrailing){
                    Image(mixedSound.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .padding()
                    Button {
                        print("이미지 변경 버튼 탭")
                        mixedSound.imageName = recipeRandomName.randomElement()!
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.black)
                            .padding(30)
                    }
                }.frame(maxWidth: .infinity)
                .padding(.horizontal, 30)
            Spacer()
        }
        .onAppear { isFocused = true }
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
        SoundSaveView(mixedSound: MixedSound(name: "Water Drop"))
    }
}
