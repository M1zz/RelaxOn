//
//  SelectedImageVIew.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/06.
//

import SwiftUI

struct SelectedImageVIew: View {
    @Binding var selectedImageNames: (base: String, melody: String, natural: String)
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
                .blendMode(.darken)
            
            // Natural
            IllustImage(imageName: selectedImageNames.natural, animateVar: opacityAnimationValues[2])
            
        }
    }

    @ViewBuilder
    func IllustImage(imageName: String, animateVar: Double) -> some View {
        Image(imageName)
            .resizable()
            .DeviceFrame()
            .opacity(animateVar)
            .animation(.linear, value: animateVar)
    }
}
