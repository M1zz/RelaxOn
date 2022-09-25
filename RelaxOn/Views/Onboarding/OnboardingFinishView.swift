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
    @EnvironmentObject var viewModel: MusicViewModel
    // MARK: - General Properties
    var mixedSound: MixedSound
    
    // MARK: - Life Cycles
    var body: some View {
        ZStack {
            CDCoverImageView(selectedImageNames: mixedSound.getImageName())
                .toBlurBackground(blurRadius: 6)
            
            VStack {
                Spacer()
                CDCoverImageView(selectedImageNames: mixedSound.getImageName())
                    .frame(width: DeviceFrame.screenWidth * 0.6,
                           height: DeviceFrame.screenWidth * 0.6)
                
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
            viewModel.userRepositoriesState.append(mixedSound)
            
            let data = getEncodedData(data: viewModel.userRepositoriesState)
            UserDefaultsManager.shared.recipes = data
            
            UserDefaultsManager.shared.notFirstVisit = true
            
            showOnboarding = false
        } label: {
            Text("START")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .light))
                .frame(width: DeviceFrame.exceptPaddingWidth,
                       height: DeviceFrame.screenHeight * 0.07)
                .background {
                    RoundedRectangle(cornerRadius: 4)
                        .foregroundColor(.relaxRealBlack)
                }
                .padding()
        }
    }
}
