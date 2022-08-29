//
//  OnboardingFinishView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/09.
//

import SwiftUI

struct OnboardingFinishView: View {
    // MARK: - State Properties
    @State var userRepositoriesState: [MixedSound] = userRepositories
    @State var onboardingNavigate: Bool = false
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    @Binding var textEntered: String
    @Binding var showOnboarding: Bool
    
    // MARK: - Life Cycles
    var body: some View {
        ZStack {
            SelectedImageBackgroundView(selectedImageNames: $selectedImageNames,
                                        opacityAnimationValues: $opacityAnimationValues)
            VStack {
                Spacer()
                SelectedImageView(framerevise: true,
                                  selectedImageNames: $selectedImageNames,
                                  opacityAnimationValues: $opacityAnimationValues)
                    .frame(width: deviceFrame.screenWidth * 0.6, height: deviceFrame.screenWidth * 0.6)
                
                Text("\(textEntered)")
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
        NavigationLink(isActive: $onboardingNavigate) {
            CdLibraryView()
                .navigationBarHidden(true)
        } label: {}
        
        Button {
            UserDefaultsManager.shared.notFirstVisit = true
            showOnboarding = false
            onboardingNavigate = true
        } label: {
            Text("START")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium))
                .frame(width: deviceFrame.exceptPaddingWidth, height: deviceFrame.screenHeight * 0.07)
                .cornerRadius(10)
                .background(.black)
        }
        .padding()
    }
}
