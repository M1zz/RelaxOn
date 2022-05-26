//
//  TitleText.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/26/22.
//

import SwiftUI

struct WhiteTitleText: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .bold()
            .foregroundColor(Color.white)
    }
}

struct TitleText_Previews: PreviewProvider {
    static var previews: some View {
        WhiteTitleText(title: "Test")
    }
}
