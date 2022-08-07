//
//  SelectedImageBackgroundView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/06.
//

import SwiftUI

struct SelectedImageBackgroundView: View {
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]

    var body: some View {
        SelectImage()
    }

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
    }

    @ViewBuilder
    func IllustImage(imageName: String, animateVar: Double) -> some View {
        Image(imageName)
            .resizable()
            .frame(width: deviceFrame().screenWidth, height: deviceFrame().screenHeight)
            .scaledToFill()
            .clipped()
//            .aspectRatio(contentMode: .fill)
            .opacity(animateVar)
            .animation(.linear, value: animateVar)
    }
}
