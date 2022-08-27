//
//  SelectedImageBackgroundView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/06.
//

import SwiftUI

struct SelectedImageBackgroundView: View {
    // MARK: - State Properties
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    
    // MARK: - Life Cycles
    var body: some View {
        SelectImage()
    }
}

// MARK: - ViewBuilder
extension SelectedImageBackgroundView {
    @ViewBuilder
    func SelectImage() -> some View {
        ZStack {
            // Base
            IllustImage(imageName: selectedImageNames.base, animateVar: opacityAnimationValues[0])

            // Melody
            IllustImage(imageName: selectedImageNames.melody, animateVar: opacityAnimationValues[1])

            // Natural
            IllustImage(imageName: selectedImageNames.whiteNoise, animateVar: opacityAnimationValues[2])

        }
        .ignoresSafeArea()
    }

    @ViewBuilder
    func IllustImage(imageName: String, animateVar: Double) -> some View {
        Image(imageName)
            .resizable()
            .opacity(animateVar)
            .animation(.linear, value: animateVar)
    }
}
