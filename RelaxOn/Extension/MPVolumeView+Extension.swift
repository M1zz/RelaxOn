//
//  MPVolumeView+Extension.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/09/26.
//

import Foundation

import UIKit
import MediaPlayer

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }

    static func getVolume() -> Float {
        return AVAudioSession.sharedInstance().outputVolume
    }
}
