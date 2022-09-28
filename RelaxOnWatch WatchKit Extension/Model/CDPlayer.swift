//
//  CDPlayer.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/28.
//

import Foundation

class CDPlayer: ObservableObject {
    static let shared = CDPlayer()
    
    var currentCDName: String = ""
    var isPlaying: Bool = false
    var volume: Float = 0.0
    var CDList: [String] = []
}
