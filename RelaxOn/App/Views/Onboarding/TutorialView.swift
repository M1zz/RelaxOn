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
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @Binding var isFirstVisit: Bool

    var body: some View {
        ZStack {
            SoundDetailView(isTutorial: true, originalSound: OriginalSound(name: "물방울", filter: .waterDrop, category: .waterDrop, defaultColor: "DCE8F5"))
            
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            Image(OnboardInfo.Tutorial.image.rawValue)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(50)
        }

        .onTapGesture {
            isFirstVisit = false
            UserDefaultsManager.shared.isFirstVisit = false
            presentationMode.wrappedValue.dismiss()
            appState.moveToTab(.home)
        }
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(isFirstVisit: .constant(true))
    }
}
