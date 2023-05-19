//
//  Float+Extension.swift
//  RelaxOn
//
//  Created by Moon Jongseek on 2022/08/25.
//

import Foundation

extension Float {
    func convert(fromRange: (Float, Float), toRange: (Float, Float)) -> Float {
        // Example: if self = 1, fromRange = (0,2), toRange = (10,12) -> solution = 11
        var value = self
        value -= fromRange.0
        value /= Float(fromRange.1 - fromRange.0)
        value *= toRange.1 - toRange.0
        value += toRange.0
        return value
    }
}
