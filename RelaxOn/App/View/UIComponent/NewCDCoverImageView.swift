//
//  CDCoverImageView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/10/31.
//

import SwiftUI

struct NewCDCoverImageView: View {
    var selectedImageNames: (baseFileName: String, melodyFileName: String, whiteNoiseFileName: String)
    
    init(selectedImageNames: (baseFileName: String, melodyFileName: String, whiteNoiseFileName: String)) {
        self.selectedImageNames = selectedImageNames
    }
    
    var body: some View {
        ZStack {
            IllustImage(selectedImageNames.baseFileName)
            IllustImage(selectedImageNames.melodyFileName)
            IllustImage(selectedImageNames.whiteNoiseFileName)
        }
    }
}

//struct NewCDCoverImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewCDCoverImageView()
//    }
//}

// MARK: - ViewBuilder
extension NewCDCoverImageView {
    @ViewBuilder
    func toBlurBackground(blurRadius: CGFloat = 30.0) -> some View {
        GeometryReader { proxy in
            ZStack {
                self
                Rectangle()
                    .fill(.black.opacity(0.3))
            }
                .scaledToFill()
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .blur(radius: blurRadius)
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    func addDefaultBackground() -> some View {
        self
            .background {
                Rectangle()
                    .fill(.white.opacity(0.2))
            }
            .cornerRadius(4)
            .clipped()
    }
    
    @ViewBuilder
    func IllustImage(_ imageName: String) -> some View {
        if imageName.isEmpty {
            Rectangle()
                .fill(.clear)
        } else {
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
    }
}

