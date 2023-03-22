//
//  Sound.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/23.
//

import Foundation

struct OldSound: Identifiable, Codable {
    let id: Int // = UUID()
    let name: String
    var soundType: SoundType
    var audioVolume: Float
    let fileName: String
    
    static let empty: (Int, SoundType) -> OldSound = {
        return OldSound(id: $0 * 10,
                     name: "Empty",
                     soundType: $1,
                     audioVolume: 0.5,
                     fileName: "")
    }
}

var baseSound: OldSound = OldSound(id: 0,
                             name: "Empty",
                             soundType: .base,
                             audioVolume: 0.0,
                             fileName: "")
var melodySound: OldSound = OldSound(id: 3,
                               name: "Empty",
                               soundType: .base,
                               audioVolume: 0.0,
                               fileName: "")
var whiteNoiseSound: OldSound = OldSound(id: 6,
                                name: "Empty",
                                soundType: .base,
                                audioVolume: 0.0,
                                fileName: "")

var mixedAudioSources: [OldSound] = []
var userRepositories: [OldMixedSound] = []