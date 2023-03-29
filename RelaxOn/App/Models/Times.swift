//
//  Times.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/03/29.
//

import Foundation

class Time: ObservableObject {
    
    @Published var selectedTimeIndexHours: Int = 0
    @Published var selectedTimeIndexMinutes: Int = 0
    @Published var selectedTimeIndexSecond: Int = 0
    
}
