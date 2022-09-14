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
    
    static let empty: (Int) -> Sound = {
        return Sound(id: $0 * 10,
                     name: "Empty",
                     soundType: .base,
                     audioVolume: 0.8,
                     fileName: "music")
    }
}

//var baseSound: Sound = Sound(id: 0,
//                             name: "Empty",
//                             soundType: .base,
//                             audioVolume: 0.0,
//                             fileName: "music")
var melodySound: Sound = Sound(id: 3,
                               name: "Empty",
                               soundType: .base,
                               audioVolume: 0.0,
                               fileName: "music")
var whiteNoiseSound: Sound = Sound(id: 6,
                                name: "Empty",
                                soundType: .base,
                                audioVolume: 0.0,
                                fileName: "music")

var mixedAudioSources: [Sound] = []
var userRepositories: [MixedSound] = []
