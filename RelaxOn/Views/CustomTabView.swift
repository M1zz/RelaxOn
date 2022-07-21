//
//  CustomTabView.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/07.
//

import SwiftUI

struct CustomTabView : View {
    
    @Binding var selected: SelectedType
    
    var body : some View {

        HStack {
            ForEach(tabs, id: \.self) { selectedTab in
                VStack(spacing: 10) {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 5)
                        .overlay(
                            Capsule()
                                .fill(self.selected == selectedTab ? Color("Forground") : Color.clear)
                                .frame(width: 55, height: 5)
                        )
                    Button(action: {
                        self.selected = selectedTab
                    }) {
                        switch selectedTab {
                        case .home :
                            VStack {
                                Image(systemName: "house.fill")
                                    .tint(self.selected == selectedTab ? ColorPalette.forground.color : .white)
                                Text(selectedTab.rawValue)
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                        case .kitchen:
                            VStack {
                                Image(systemName: "sparkles")
                                    .tint(self.selected == selectedTab ? ColorPalette.forground.color : .white)
                                Text(selectedTab.rawValue)
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: 110)
        .background(ColorPalette.tabBackground.color)
        .cornerRadius(12, corners: [.topLeft, .topRight])
    }
}


struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(selected: .constant(.home))
    }
}
