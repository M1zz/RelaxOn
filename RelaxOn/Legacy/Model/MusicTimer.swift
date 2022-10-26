//
//  MusicTimer.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/31.
//

import Foundation

struct MusicTimer {
  
    var timerStop: Bool = false
    var remainedSecond: Int = -1
    
    var timerOn: Bool {
        remainedSecond > -1
    }
}
