//
//  SoundSaveView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundSaveView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State var soundSavedName: String = ""
    @State var mixedSound: MixedSound
    var imageFiles: [String] = ["Recipe1", "Recipe2", "Recipe3", "Recipe4", "Recipe5",
                                "Recipe6", "Recipe7", "Recipe8", "Recipe9", "Recipe10"]

    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .bold()
                            .padding(10)
                    }.offset(x: 0, y: -70)
                    
                    Spacer()

                    Button {
                        print("save")
                        isFocused = false
                        let newMixedSound = MixedSound(name: soundSavedName, imageName: mixedSound.imageName)
                        do {
                            try UserFileManager.shared.saveMixedSound(newMixedSound)
                            presentationMode.wrappedValue.dismiss() // 성공적으로 저장되면 dismiss
                        } catch {
                            print(error.localizedDescription)
                            isShowingAlert = true
                            alertMessage = "저장에 실패했습니다. \(error.localizedDescription)"
                        }
                    } label: {
                        Text("Save")
                            .foregroundColor(.black)
                            .font(.system(size: 20))
                            .bold()
                            .padding(10)
                    }.offset(x: 0, y: -70)
                }

                TextField("\(mixedSound.name)", text: $soundSavedName)
                    .frame(minWidth: 150, idealWidth: 150, maxWidth: 300,
                           minHeight: 80, idealHeight: 80, maxHeight: 80,
                           alignment: .center)
                    .padding(EdgeInsets(top: 100, leading: 180, bottom: 100, trailing: 150))
                    .keyboardType(.default)
                    .autocorrectionDisabled(true)
                    .focused($isFocused)
                    .font(.title)
                    .underline(true)
                
                ZStack{
                    Image(mixedSound.imageName)
                        .resizable()
                        .frame(width: 300, height: 300)
                    Button {
                        print("이미지 변경 버튼")
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .bold()
                        
                    }.offset(x: 120, y: -120)
                }
            }
            .onAppear {
                isFocused = true
            }
        }
        .background(Color.white)
        .onTapGesture {
            isFocused = false
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
