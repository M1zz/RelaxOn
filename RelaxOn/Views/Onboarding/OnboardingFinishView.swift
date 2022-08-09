//
//  OnboardingFinishView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/09.
//

import SwiftUI

struct OnboardingFinishView: View {
    @State var userRepositoriesState: [MixedSound] = userRepositories
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    @Binding var showOnboarding: Bool
    var body: some View {
        ZStack {

            SelectedImageBackgroundView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues)

            VStack {
                SelectedImageVIew(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues)
                Text("TempName")
                Spacer()
                StartButton()
            }
        }.navigationBarHidden(true)
    }

    @ViewBuilder
    func StartButton() -> some View {
        NavigationLink {
            CdLibraryView()
        } label: {
            Text("START")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .light))
        }
        .frame(width: deviceFrame.exceptPaddingWidth, height: deviceFrame.screenHeight * 0.07)
        .background(.black)
        .padding()
        .simultaneousGesture(TapGesture().onEnded { _ in
            UserDefaultsManager.shared.standard.set(true, forKey: UserDefaultsManager.shared.notFirstVisit)
            showOnboarding = false
        })
        .navigationBarHidden(true)
    }
}
