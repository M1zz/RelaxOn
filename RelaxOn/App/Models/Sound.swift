//
//  Sound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/15.
//

import Foundation

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
