//
//  Sound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/15.
//

import Foundation

/**
 앱 번들에 있는 원본 사운드를 불러오기 위한 구조체
 */
// TODO: OriginalSound로 교체 필요
struct Sound {
    let name: String
    var volume: Float
    let imageName: String
    
    init(name: String, volume: Float = 0.5, imageName: String = "placeholderImage") {
        self.name = name
        self.volume = volume
        self.imageName = imageName
    }
}

/**
 앱 번들에 있는 원본 사운드를 불러오기 위한 구조체
 */
struct OriginalSound {
    let name: String
    let imageName: String
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}
