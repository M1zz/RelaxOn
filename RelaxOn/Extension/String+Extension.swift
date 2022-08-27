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
    
    var addSpaceBeforeUppercase: String {
        var string = self
        for (index, char) in string.enumerated() {
            // 대문자 일 때,
            if char.isUppercase {
                // 해당 인덱스 앞에 띄어쓰기 추가
                let insertIndex = string.index(self.startIndex, offsetBy: index)
                string.insert(contentsOf: " ", at: insertIndex)
            }
        }
        return string
    }
    
    var convertUppercaseFirstChar: String {
        var string = self
        
        // 첫 글자 빼기
        string.removeFirst()
        
        // 첫 글자 대문자 변환
        let firstChar = self.first?.uppercased() ?? ""
        
        // 첫 글자 + 나머지
        return firstChar + string
    }
}
