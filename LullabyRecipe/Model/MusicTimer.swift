//
//  Timer.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/10.
//

import SwiftUI

struct MusicTimer {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var isTimerOn: Bool = false
    var isTimerStop: Bool = false

    var remainedSecond: Int = 0
    
    mutating func setTime(second: Int) {
        remainedSecond = second
    }

}
