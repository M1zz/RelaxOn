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
            Spacer(minLength: 100)
            
            // TODO: 선택한 사운드 이미지 가져오기
            Image("placeholderImage")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .padding(30)
            
            // TODO: 선택한 사운드 제목 가져오기
            Text("Title")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            HStack(alignment: .center) {
                Spacer(minLength: 80)
                Button {

                    // TODO: 저장된 음원 목록 중 뒤쪽 음원으로 이동
                } label: {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .padding()
                }
                
                Spacer()
                
                Button {
                    // TODO: 선택한 사운드 재생/일시정지 토글
                } label: {
                    // TODO: 음원 재생 여부에 따라 토글되도록 설정, 하드코딩 금지
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .padding()
                }
                
                
                Button {
                    // TODO: 저장된 음원 목록 중 앞쪽 음원으로 이동
                } label: {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer(minLength: 80)
            }
            Spacer(minLength: 100)
        }
    }
}

struct FullModalSoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerFullModalView()
    }
}
