//
//  AudioVariation.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/25.
//

import Foundation

/**
 오디오 변형 관리를 위한 구조체
 */
struct AudioVariation: Codable {
    var volume: Float
    var pitch: Float
    var interval: Float
    
    init() {
        self.volume = 0.5
        self.pitch = 0
        self.interval = 1.0
    }
    
    init(volume: Float, pitch: Float, interval: Float = 1.0) {
        self.volume = volume
        self.pitch = pitch
        self.interval = interval
    }
}
