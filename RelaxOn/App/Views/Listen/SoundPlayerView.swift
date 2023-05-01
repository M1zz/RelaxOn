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
            // Todo: 선택사운드 제목 받아 표시하기
            Text("Title")
                .font(.largeTitle)
            
            Spacer()
            
            // Todo: 선택사운드 이미지 받아 표시하기
            Image("placeholderImage")
                .resizable()
                .cornerRadius(12)
                .frame(width: 300, height: 300)
            
            Spacer()
            
            HStack {
                Button {
                    //ToDo : 뒤로가기 작동
                } label: {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    // ToDo : 재생하기 작동
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    // ToDo : 앞으로 가기
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
