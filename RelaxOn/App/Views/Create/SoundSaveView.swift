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
        }
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSaveView(volume: .constant(Float()))
    }
}
