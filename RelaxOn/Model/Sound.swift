//
//  Fresh.swift
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
}

enum SoundType: String, Codable {
    case base
    case melody
    case whiteNoise
}

var baseSounds = [
    Sound(id: 0,
          name: "Empty",
          soundType: .base,
          audioVolume: 0.8,
          fileName: "music"),
    Sound(id: 1,
          name: BaseAudioName.longSun.displayName,
          soundType: .base,
          audioVolume: 0.8,
          fileName: BaseAudioName.longSun.fileName),
    Sound(id: 2,
          name: BaseAudioName.spaceMid.displayName,
          soundType: .base,
          audioVolume: 0.8,
          fileName: BaseAudioName.spaceMid.fileName),
    Sound(id: 3,
          name: BaseAudioName.spaceLow.displayName,
          soundType: .base,
          audioVolume: 0.8,
          fileName: BaseAudioName.spaceLow.fileName),
    Sound(id: 4,
          name: BaseAudioName.spaceHigh.displayName,
          soundType: .base,
          audioVolume: 0.8,
          fileName: BaseAudioName.spaceHigh.fileName),
    Sound(id: 5,
          name: BaseAudioName.oxygen.displayName,
          soundType: .base,
          audioVolume: 0.8,
          fileName: BaseAudioName.oxygen.fileName),
]

var melodySounds = [
    Sound(id: 10,
          name: "Empty",
          soundType: .melody,
          audioVolume: 1.0,
          fileName: "music"),
    Sound(id: 11,
          name: MelodyAudioName.ambient.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          fileName: MelodyAudioName.ambient.fileName),
    Sound(id: 12,
          name: MelodyAudioName.garden.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          fileName: MelodyAudioName.garden.fileName),
    Sound(id: 13,
          name: MelodyAudioName.gymnopedie.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          fileName: MelodyAudioName.gymnopedie.fileName),
    Sound(id: 14,
          name: MelodyAudioName.relaxing.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          fileName: MelodyAudioName.relaxing.fileName),
    Sound(id: 15,
          name: MelodyAudioName.wisdom.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          fileName: MelodyAudioName.wisdom.fileName)
]

var whiteNoiseSounds = [
    Sound(id: 20,
          name: "Empty",
          soundType: .whiteNoise,
          audioVolume: 0.4,
          fileName: "music"),
    Sound(id: 21,
          name: WhiteNoiseAudioName.dryGrass.displayName,
          soundType: .whiteNoise,
          audioVolume: 0.4,
          fileName: WhiteNoiseAudioName.dryGrass.fileName),
    Sound(id: 22,
          name: WhiteNoiseAudioName.stream.displayName,
          soundType: .whiteNoise,
          audioVolume: 0.4,
          fileName: WhiteNoiseAudioName.stream.fileName),
    Sound(id: 23,
          name: WhiteNoiseAudioName.summerField.displayName,
          soundType: .whiteNoise,
          audioVolume: 0.4,
          fileName: WhiteNoiseAudioName.summerField.fileName),
    Sound(id: 24,
          name: WhiteNoiseAudioName.umbrellaRain.displayName,
          soundType: .whiteNoise,
          audioVolume: 0.4,
          fileName: WhiteNoiseAudioName.umbrellaRain.fileName),
    Sound(id: 25,
          name: WhiteNoiseAudioName.wave.displayName,
          soundType: .whiteNoise,
          audioVolume: 0.4,
          fileName: WhiteNoiseAudioName.wave.fileName)
]

let emptySound: Sound = Sound(id: 0,
                               name: "Empty",
                               soundType: .base,
                               audioVolume: 0.0,
                               fileName: "music")

var baseSound: Sound = Sound(id: 0,
                             name: "Empty",
                             soundType: .base,
                             audioVolume: 0.0,
                             fileName: "music")
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
