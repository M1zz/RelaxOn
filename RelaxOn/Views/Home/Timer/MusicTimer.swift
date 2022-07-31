//
//  MusicTimer.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/31.
//

import Foundation

struct MusicTimer {
  
    var timerStop: Bool = false
    var remainedSecond: Int = 0
    
    var timerOn: Bool {
        remainedSecond > 0
    }
}
