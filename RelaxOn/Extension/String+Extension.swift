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
    
    var displayName: String {
        var string = self
        string.removeFirst()
        
        let firstChar = self.first?.uppercased() ?? ""
        for char in string {
            if char.isUppercase {
                if let insertIndex = string.range(of: "\(char)")?.lowerBound {
                    string.insert(contentsOf: " ", at: insertIndex)
                }
            }
        }
        return firstChar + string
    }
}
