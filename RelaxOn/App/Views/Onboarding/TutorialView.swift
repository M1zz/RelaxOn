//
//  TutorialView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

/**
 튜토리얼화면 :
 온보딩 마지막 화면으로 터치 시 사라지는 일회성 뷰
 */

import SwiftUI

struct TutorialView: View {
    
    var body: some View {
        ZStack {
            // TODO: AudioManager를 활용해서 음악 끄기
            SoundDetailView(originalSound: Sound(name:"Garden"))
            Color.black
                .opacity(0.5)
            Image(OnboardInfo.Tutorial.tutorialImage.rawValue)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(50)
        }.ignoresSafeArea()
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
