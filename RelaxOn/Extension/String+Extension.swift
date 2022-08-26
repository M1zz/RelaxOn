//
//  String+Extension.swift
//  RelaxOn
//
//  Created by Moon Jongseek on 2022/08/25.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "localizable", value: self, comment: "")
    }
}
