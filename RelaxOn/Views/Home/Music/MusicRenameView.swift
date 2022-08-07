//
//  MusicRenameView.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/08/06.
//

import SwiftUI

struct MusicRenameView: View {
    var mixedSound: MixedSound
    @State private var cdName = ""
    
    var body: some View {
        ZStack{
            Color.yellow
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                TitleLabel(text: "Please rename")
                TitleLabel(text: "this CD")
                    .padding(.bottom, 22)
                
                TextField(mixedSound.name, text: $cdName)
                    .padding(.bottom, 8)
                Rectangle()
                    .fill(.white)
                    .frame(height: 1)
                    .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
    }
}

extension MusicRenameView {
    @ViewBuilder
    func TitleLabel(text: String) -> some View {
        Text(text)
            .font(.system(.title, design: .default))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
    }
}

//struct MusicRenameView_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicRenameView()
//    }
//}
