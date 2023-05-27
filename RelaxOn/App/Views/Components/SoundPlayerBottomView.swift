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
            Image("WaterDrop")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color(hex: "DCE8F5"))
                .cornerRadius(8)
            
            Text("나의 물방울 소리")
                .font(.system(size: 18, weight: .bold))
                .padding(.leading, 20)
                .foregroundColor(Color(.Text))
            
            Spacer()
            
            Button(action: {
                
            }) {
                Image(systemName: PlayPauseButton.play.rawValue)
                    .padding(.trailing, 20)
                    .foregroundColor(Color(.Text))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color(.SoundPlayerBottom))
        
    }
}

struct BottomSoundPlayerBarView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerBottomView()
    }
}
