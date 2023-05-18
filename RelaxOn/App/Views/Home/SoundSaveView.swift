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
    @ObservedObject var viewModel = MixedSoundsViewModel()
    @EnvironmentObject var appState: AppState
    @FocusState private var isFocused: Bool
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State var soundSavedName: String = ""
    @State var mixedSound: MixedSound
    
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .frame(width: 10, height: 20)
                        .bold()
                        .foregroundColor(.gray)
                }
                // TODO: OFFSET 지양하기
                .offset(x: 15, y: -70)
                
                Spacer()
                
                Text(mixedSound.name)
                    .font(.system(size: 24, weight: .bold))
                    // TODO: OFFSET 지양하기
                    .offset(y: -70)
                
                Spacer()
                
                Button {
                    // TODO: View에 있는 Action은 최대한 간소화 할 것
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
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                        .bold()
                }
                // TODO: OFFSET 지양하기
                .offset(x: -10, y: -70)
                
            }.frame(width: 400)
            
            // TODO: 출시 Sprint Backlog 이미지에 맞게 수정 필요
            TextField(mixedSound.name, text: $soundSavedName)
                .frame(width: 160, height: 80, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .keyboardType(.default)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .font(.title)
                .underline(true)
            
            ZStack{
                Image(mixedSound.imageName)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .cornerRadius(12)
                Button {
                    print("이미지 변경 버튼 탭")
                    mixedSound.imageName = recipeRandomName.randomElement()!
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                        .bold()
                }
                // TODO: OFFSET 지양하기
                .offset(x: 120, y: -120)
            }
        }
        .onAppear { isFocused = true }
        .background(Color.white)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


struct SoundSaveView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSaveView(mixedSound: MixedSound(name: "Water Drop"))
    }
}
