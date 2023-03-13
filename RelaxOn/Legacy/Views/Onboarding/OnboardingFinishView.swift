//
//  OnboardingFinishView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/09.
//

import SwiftUI

struct OnboardingFinishView: View {
    // MARK: - State Properties
    @Binding var showOnboarding: Bool
    
    // MARK: - General Properties
    var mixedSound: OldMixedSound
    
    // MARK: - Life Cycles
    var body: some View {
        ZStack {
            CDCoverImageView(selectedImageNames: mixedSound.getImageName())
                .toBlurBackground(blurRadius: 6)
            
            VStack {
                Spacer()
                CDCoverImageView(selectedImageNames: mixedSound.getImageName())
                    .frame(width: deviceFrame.screenWidth * 0.6,
                           height: deviceFrame.screenWidth * 0.6)
                
                Text("\(mixedSound.name)")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
                    .padding()
                Spacer()
                
                StartButton()
            }
        }.navigationBarHidden(true)
    }
}

// MARK: - ViewBuilder
extension OnboardingFinishView {
    @ViewBuilder
    func StartButton() -> some View {
        Button {
            userRepositories.append(mixedSound)
            
            let data = getEncodedData(data: userRepositories)
            OldUserDefaultsManager.shared.recipes = data
            
            OldUserDefaultsManager.shared.notFirstVisit = true
            
            showOnboarding = false
        } label: {
            Text("START")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .light))
                .frame(width: deviceFrame.exceptPaddingWidth,
                       height: deviceFrame.screenHeight * 0.07)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.relaxRealBlack)
                }
                .padding()
        }
    }
}
