//
//  SoundSaveView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundSaveView: View {
    
    @FocusState private var isFocused: Bool
    @Binding var volume: Float
    @State var soundSavedName: String = ""
    @State var imageFileNumber: Int = 0
    var imageFiles: [String?] = ["Recipe1", "Recipe2", "Recipe3", "Recipe4", "Recipe5",
                                 "Recipe6", "Recipe7", "Recipe8", "Recipe9", "Recipe10"]
    
    var body: some View {
        VStack{
            HStack{
                //취소 버튼
                Button {
                    print("cancel")
                } label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .bold()
                        .padding(10)
                }.offset(x: 0, y: -70)
                
                Spacer()
                
                //저장 버튼
                Button {
                    print("save")
                    isFocused = false
                } label: {
                    Text("Save")
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                        .bold()
                        .padding(10)
                }.offset(x: 0, y: -70)
            }
            
            //제목 입력
            TextField("\(volume)", text: $soundSavedName)
                .frame(minWidth: 150, idealWidth: 150, maxWidth: 300,
                       minHeight: 80, idealHeight: 80, maxHeight: 80,
                       alignment: .center)
                .padding(EdgeInsets(top: 100, leading: 150, bottom: 100, trailing: 150))
                .keyboardType(.default)
                .autocorrectionDisabled(true)
                .focused($isFocused)
                .font(.title)
                .underline(true)
            
            //앨범 이미지
            Image(imageFiles[imageFileNumber]!)
                .resizable()
                .frame(width: 300, height: 300)
        }
        
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSaveView(volume: .constant(Float()))
    }
}
