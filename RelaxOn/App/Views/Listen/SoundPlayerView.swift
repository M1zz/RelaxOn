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
            
            // TODO: 선택한 사운드 제목 가져오기
            Text("Title")
                .font(.largeTitle)
            
            Spacer()
            
            // TODO: 선택한 사운드 이미지 가져오기
            Image("placeholderImage")
                .resizable()
                .cornerRadius(12)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            HStack {
                Button {
            // TODO: 선택한 사운드 뒤로가기 기능
                } label: {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    // TODO: 선택한 사운드 재생/일시정지 기능
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    // TODO: 선택한 사운드 앞으로 가기 기능
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
