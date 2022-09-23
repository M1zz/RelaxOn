//
//  ViewModifiers.swift
//  RelaxOn
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
    
    func DeviceFrameCenter() -> some View {
        self
            .frame(width: DeviceFrame.exceptPaddingWidth, height: DeviceFrame.exceptPaddingWidth, alignment: .center)
    }
}
