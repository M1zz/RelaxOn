//
//  Sound.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/23.
//

import Foundation

struct Sound: Identifiable, Codable {
    let id: Int // = UUID()
    let name: String
    var soundType: SoundType
    var audioVolume: Float
    let fileName: String
    
    static let empty: (SoundType) -> Sound = { type in
        Sound(id: 0,
              name: "Empty",
              soundType: type,
              audioVolume: 0.5,
              fileName: "")
    }
}

var baseSound: Sound = Sound.empty(.base)
var melodySound: Sound = Sound.empty(.melody)
var whiteNoiseSound: Sound = Sound.empty(.whiteNoise)

