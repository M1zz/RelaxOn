//
//  DummyTimerView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/10.
//

import SwiftUI

struct DummyTimerView: View {
    @ObservedObject var timer = TimerManager.shared
    @State var second: Double = 0

    var body: some View {
        if timer.isTimerOn {
            editTimerView
        } else {
            setTimerView
        }
    }
    
    var setTimerView: some View {
        VStack {
            Text("\(second)")
            Slider(value: $second, in: 1...60, step: 1)
            Button {
                timer.start(time: Int(second))
            } label: {
                Text("start")
            }
        }
    }
    
    var editTimerView: some View {
        VStack {
            Text("\(timer.getRemainedSecond())")
            Button {
                timer.musicTimer.isTimerOn = false
            } label : {
                Text("cancel")
            }
        }
    }
}

struct DummyTimerView_Previews: PreviewProvider {
    static var previews: some View {
        DummyTimerView()
    }
}
