//
//  TimerProgressView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/26.
//

import SwiftUI

/**
 타이머가 작동되는 동안의 View
 */
struct TimerProgressView: View {
    
    @ObservedObject var timerManager: TimerManager
    @State var progress: Double = 1.0
    
    var body: some View {
        ZStack {
            CircleProgressView(timerManager: timerManager)
            timerManager.getTimeText(timerManager: timerManager)
        }
    }
}


struct TimerProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TimerProgressView(timerManager: TimerManager())
    }
}
