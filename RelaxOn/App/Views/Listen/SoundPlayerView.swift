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
                    // TODO: 선택한 사운드 뒤로가기 기능
                } label: {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .padding()
                }
                
                Spacer()
                
                Button {
                    // TODO: 선택한 사운드 재생/일시정지 기능
                } label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .padding()
                }
                
                
                Button {
                    // TODO: 선택한 사운드 앞으로 가기 기능
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

struct SoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerView()
    }
}
