//
//  TimerProgressView.swift
//  RelaxOn
//
//  Created by 황석현 on 2023/04/12.
//

import SwiftUI

struct TimerProgressView: View {
    
    @State var timer: Timer?
    @EnvironmentObject var timeData: Time
    @State private var hours : [Int] = Array(1...24)
    @State private var minutes : [Int] = Array(0...59)
    @State var remainingSeconds: Int = 0
    @State var isShowingTimerProgressView: Bool = false
    
    
    func startTimer() {
        remainingSeconds = timeData.selectedTimeIndexHours * 3600 + timeData.selectedTimeIndexMinutes * 60
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            remainingSeconds -= 1
            
            if remainingSeconds <= 0 {
                timer.invalidate()
                remainingSeconds = 0
            }
            
            if remainingSeconds == 0 {
                isShowingTimerProgressView = false
                return
            }
            
        }
    }
    
    var body: some View {
        Text(String(format: "%02d:%02d:%02d", max(remainingSeconds / 3600, 0), max((remainingSeconds % 3600) / 60, 0), max(remainingSeconds % 60, 0)))
            .font(.system(size: 50))
            .fontWeight(.semibold)
            .padding()
            .onAppear {
                startTimer()
            }
    }
}
