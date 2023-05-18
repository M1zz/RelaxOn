//
//  SoundPlayerFullModalView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 풀 모달 화면으로 보여지는 음원 플레이어 VIew
 */
struct SoundPlayerFullModalView: View {
    
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
                    // TODO: 저장된 음원 목록 중 뒤쪽 음원으로 이동
                } label: {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    // TODO: 선택한 사운드 재생/일시정지 토글
                } label: {
                    // TODO: 음원 재생 여부에 따라 토글되도록 설정, 하드코딩 금지
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button {
                    // TODO: 저장된 음원 목록 중 앞쪽 음원으로 이동
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

struct FullModalSoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerFullModalView()
    }
}
