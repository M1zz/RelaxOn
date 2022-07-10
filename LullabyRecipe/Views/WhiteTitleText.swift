//
//  TitleText.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/26/22.
//

import SwiftUI

struct WhiteTitleModifier: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(Font.title.weight(.bold))
            .foregroundColor(Color.white)
    }
}

extension View {
    func WhiteTitleText(backgroundColor : Color = .green, foregroundColor : Color = .white) -> ModifiedContent<Self, WhiteTitleModifier> {
        return modifier(WhiteTitleModifier())
    }
}
