//
//  Fresh.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import Foundation

struct Sound: Identifiable, Codable {
    let id: Int // = UUID()
    let name: String
    var soundType: SoundType
    var audioVolume: Float
    let imageName: String
}

enum SoundType: String, Codable {
    case base
    case melody
    case natural
}

var baseSounds = [
    Sound(id: 0,
          name: "Empty",
          soundType: .base,
          audioVolume: 0.8,
          imageName: "music"),
    Sound(id: 1,
          name: BaseAudioName.longSun.displayName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.longSun.fileName),
    Sound(id: 2,
          name: BaseAudioName.spaceMid.displayName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.spaceMid.fileName),
    Sound(id: 3,
          name: BaseAudioName.spaceLow.displayName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.spaceLow.fileName),
    Sound(id: 4,
          name: BaseAudioName.spaceHigh.displayName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.spaceHigh.fileName),
    Sound(id: 5,
          name: BaseAudioName.oxygen.displayName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.oxygen.fileName),
]

var melodySounds = [
    Sound(id: 10,
          name: "Empty",
          soundType: .melody,
          audioVolume: 1.0,
          imageName: "music"),
    Sound(id: 11,
          name: MelodyAudioName.ambient.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.ambient.fileName),
    Sound(id: 12,
          name: MelodyAudioName.garden.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.garden.fileName),
    Sound(id: 13,
          name: MelodyAudioName.gymnopedia.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.gymnopedia.fileName),
    Sound(id: 14,
          name: MelodyAudioName.relaxing.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.relaxing.fileName),
    Sound(id: 15,
          name: MelodyAudioName.wisdom.displayName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.wisdom.fileName)
]

var naturalSounds = [
    Sound(id: 20,
          name: "Empty",
          soundType: .natural,
          audioVolume: 0.4,
          imageName: "music"),
    Sound(id: 21,
          name: NaturalAudioName.dryGrass.displayName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.dryGrass.fileName),
    Sound(id: 22,
          name: NaturalAudioName.stream.displayName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.stream.fileName),
    Sound(id: 23,
          name: NaturalAudioName.summerField.displayName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.summerField.fileName),
    Sound(id: 24,
          name: NaturalAudioName.umbrellaRain.displayName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.umbrellaRain.fileName),
    Sound(id: 25,
          name: NaturalAudioName.wave.displayName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.wave.fileName)
]

let emptySound: Sound = Sound(id: 0,
                               name: "Empty",
                               soundType: .base,
                               audioVolume: 0.0,
                               imageName: "music")

var baseSound: Sound = Sound(id: 0,
                             name: "Empty",
                             soundType: .base,
                             audioVolume: 0.0,
                             imageName: "music")
var melodySound: Sound = Sound(id: 3,
                               name: "Empty",
                               soundType: .base,
                               audioVolume: 0.0,
                               imageName: "music")
var naturalSound: Sound = Sound(id: 6,
                                name: "Empty",
                                soundType: .base,
                                audioVolume: 0.0,
                                imageName: "music")

var mixedAudioSources: [Sound] = []
var userRepositories: [MixedSound] = []
