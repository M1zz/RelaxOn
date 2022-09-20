//
//  Static.swift
//  RelaxOn
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI

let recipeRandomName = ["Recipe1","Recipe2","Recipe3","Recipe4","Recipe5","Recipe6","Recipe7","Recipe8","Recipe9","Recipe10"]

let viewHorizontalPadding: CGFloat = 10

final class deviceFrame {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static var exceptPaddingWidth: CGFloat {
        return screenWidth - 40
    }
}

/*
 * 사용 방법:

        init() {
            Theme.navigationBarColors(background: .systemFill, titleColor: .white)
        }
 
        var body: some View {

        } ~

 위 코드를 View 안에 넣고 원하는 UIColor 의 Color 로 설정해주면 된다.
 */

// MARK: Navigation Bar Color change
final class Theme {
    static func navigationBarColors(background: UIColor?, titleColor: UIColor? = nil, tintColor: UIColor? = nil ) {

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear

        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]

        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance

        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}
