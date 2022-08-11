//
//  SelectedImageVIew.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/06.
//

import SwiftUI

struct SelectedImageView: View {
    @State var framerevise: Bool = false
    @Binding var selectedImageNames: (base: String, melody: String, whiteNoise: String)
    @Binding var opacityAnimationValues: [Double]
    
    var body: some View {
        SelectImage()
    }
    
    @ViewBuilder
    func SelectImage() -> some View {
        ZStack {
            if !framerevise {
                Rectangle()
                    .DeviceFrame()
                    .background(.gray)
            }
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
        if framerevise {
            Image(imageName)
                .resizable()
                .opacity(animateVar)
                .animation(.linear, value: animateVar)
        } else {
            Image(imageName)
                .resizable()
                .DeviceFrame()
                .opacity(animateVar)
                .animation(.linear, value: animateVar)
        }
    }
}
