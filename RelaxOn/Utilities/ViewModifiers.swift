//
//  ViewModifiers.swift
//  LullabyRecipe
//
//  Created by 이가은 on 2022/07/14.
//

import SwiftUI


extension View {
    func WhiteTitleText() -> some View {
        self
            .font(Font.title.weight(.bold))
            .foregroundColor(Color.white)
    }
    
    func DeviceFrame() -> some View {
        self
            .frame(width: deviceFrame.exceptPaddingWidth, height: deviceFrame.exceptPaddingWidth, alignment: .center)
    }
}
