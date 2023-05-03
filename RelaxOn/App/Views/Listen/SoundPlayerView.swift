//
//  SoundPlayerView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/19.
//

import SwiftUI

struct SoundPlayerView: View {
    
    var body: some View {
        VStack {
            
            Text("Title")
                .font(.largeTitle)
            
            Spacer()
            
            
            Image("placeholderImage")
                .resizable()
                .cornerRadius(12)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
            }.frame(width: 230)
        }.frame(height: 445)
    }
}

struct SoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerView()
    }
}
