//
//  SystemVolumeControl.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/09/14.
//

import Foundation
import MediaPlayer
import AVFoundation

struct SystemVolumeControl {
    static let volumeView = MPVolumeView()
    static let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
    
    static func setVolume(volume: Float) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
    
    static func getVolume() -> Float {
        var volume: Float = 0.0
        
        let queue = DispatchQueue(label: "com.app.queue")
        queue.sync {
            volume = slider?.value ?? 0.0
        }
        
        return volume
    }
}
