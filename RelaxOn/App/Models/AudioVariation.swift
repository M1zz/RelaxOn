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
    
    init(volume: Float = 0.5, pitch: Float = 0, interval: Float = 1.0) {
        self.volume = volume
        self.pitch = pitch
        self.interval = interval
    }
}
