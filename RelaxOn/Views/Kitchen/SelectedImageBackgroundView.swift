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

struct CDCoverImageView: View {
    // MARK: - State Properties
    var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    
    // MARK: - Life Cycles
    var body: some View {
        ZStack {
            IllustImage(imageName: selectedImageNames.base)
            IllustImage(imageName: selectedImageNames.melody)
            IllustImage(imageName: selectedImageNames.whiteNoise)
        }
        .cornerRadius(4)
    }
}

// MARK: - ViewBuilder
extension CDCoverImageView {
    @ViewBuilder
    func toBackground() -> some View {
        GeometryReader { proxy in
            self
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .blur(radius: 30)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func IllustImage(imageName: String) -> some View {
        Image(imageName)
            .resizable()
    }
}
