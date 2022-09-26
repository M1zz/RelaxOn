//
//  SystemVolumeControl.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/09/14.
//

import Foundation
import MediaPlayer

struct SystemVolumeControl {
    static func setVolume(volume: Float) {
        MPVolumeView.setVolume(volume)
    }
    
    static func getVolume() -> Float {
        return MPVolumeView.getVolume()
    }
}
