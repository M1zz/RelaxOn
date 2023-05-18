//
//  Sound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/15.
//

import Foundation

// TODO: OriginalSound로 이름 변경
// TODO: 내부 구조 변경

/**
 앱 번들에 있는 원본 사운드를 불러오기 위한 구조체
 */
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
