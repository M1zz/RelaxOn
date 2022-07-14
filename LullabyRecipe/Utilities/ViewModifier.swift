//
//  ViewModifier.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/26/22.
//

import SwiftUI

extension View {
    func WhiteTitleText() -> some View {
        self
            .font(Font.title.weight(.bold))
            .foregroundColor(Color.white)
    }
}
