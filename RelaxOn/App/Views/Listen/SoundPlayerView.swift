//
//  SoundPlayerView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/19.
//

import SwiftUI

// ListenListView에서 Sound를 선택한다
// 선택한 Sound의 제목이 표시된다
// 선택한 Sound의 이미지가 표시된다
// 사운드 멈춤 재생 정지 버튼이 표시된다
struct SoundPlayerView: View {
    
    var body: some View {
        VStack {
            // Sound의 제목을 받아온다
            Text("Title")
                .font(.largeTitle)
            
            Spacer()
            
            // Sound의 이미지를 받아온다
            Image("placeholderImage")
                .resizable()
                .frame(width: 300, height: 300)
            
            Spacer()
            
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.black)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.black)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "pause.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color.black)
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
