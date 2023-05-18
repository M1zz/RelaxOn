//
//  SoundPlayerBottomView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 앱 내부 하단에 위치한 플레이어 바 형태의 View
 */
struct SoundPlayerBottomView: View {
    
    var body: some View {
        
        HStack {
            Spacer(minLength: 80)
            
            // TODO: 재생하는 사운드의 이미지 가져오기
            Image(systemName: "play.fill")
                .frame(width: 60, height: 60)
                .background(.foreground.opacity(0.08)).cornerRadius(10)
                .padding()
            
            Spacer()
            
            // TODO: 선택한 사운드 제목 가져오기
            Text("Title")
                .frame(width: 210,alignment: .leading)
                .font(.title)
            
            Spacer()
            
            Button {
                // TODO: 선택한 사운드를 재생
            } label: {
                Image(systemName: "play.fill")
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color.black)
            }
            Spacer(minLength: 80)
        }
        .background(Color.systemGrey1)
        .ignoresSafeArea()
    }
}

struct BottomSoundPlayerBarView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerBottomView()
    }
}
