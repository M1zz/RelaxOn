//
//  Sound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/15.
//

import Foundation

struct Sound: Codable {
    let name: String
    var audioVolume: Float
    let fileName: String
    
    init(name: String, audioVolume: Float, fileName: String) {
        self.name = name
        self.audioVolume = audioVolume
        self.fileName = fileName
    }
    
    static let empty: (Int) -> Sound = { id in
        Sound(name: "Empty", audioVolume: 0.5, fileName: "")
    }
}
