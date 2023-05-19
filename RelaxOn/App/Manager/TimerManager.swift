//
//  TimerManager.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/26.
//

import Foundation

/**
 Timer의 시간을 감지하는 객체
 */
class TimerManager: ObservableObject {

    @Published var selectedTimeIndexHours: Int = 0
    @Published var selectedTimeIndexMinutes: Int = 0

}
