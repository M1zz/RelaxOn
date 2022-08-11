//
//  Extension.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/08/02.
//

import SwiftUI
import UIKit

extension Color {
    // Main Color
    static let relaxBlack = Color("RelaxBlack")
    static let relaxRealBlack = Color("RelaxRealBlack")
    static let relaxNightBlue = Color("RelaxNightBlue")
    static let relaxLavender = Color("RelaxLavender")
    static let relaxDimPurple = Color("RelaxDimPurple")
    // System Color
    static let systemGrey1 = Color("SystemGrey1")
    static let systemGrey2 = Color("SystemGrey2")
    static let systemGrey3 = Color("SystemGrey3")
}


extension UIColor {
    static let relaxBlack = UIColor(named: "RelaxBlack")
    static let relaxRealBlack = UIColor(named: "RelaxRealBlack")
    static let relaxNightBlue = UIColor(named: "RelaxNightBlue")
    static let relaxLavender = UIColor(named: "RelaxLavender")
    static let relaxDimPurple = UIColor(named: "RelaxDimPurple")

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "localizable", value: self, comment: "")
    }
}
