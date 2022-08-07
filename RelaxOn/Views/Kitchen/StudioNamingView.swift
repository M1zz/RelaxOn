//
//  StudioNamingView.swift
//  RelaxOn
//
//  Created by 김연호 on 2022/08/07.
//

import SwiftUI

struct StudioNamingView: View {
    @Binding var selectedImageNames: (base: String, melody: String, natural: String)
    @Binding var opacityAnimationValues: [Double]
    var body: some View {
        ZStack{
            SelectedImageBackgroundView(selectedImageNames: $selectedImageNames, opacityAnimationValues: $opacityAnimationValues)
                .ignoresSafeArea()
        }.navigationBarHidden(true)
    }
}

