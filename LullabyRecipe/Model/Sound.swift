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

var baseSounds = [
    Sound(id: 0,
          name: "Empty",
          soundType: .base,
          audioVolume: 0.8,
          imageName: "music"),
    Sound(id: 1,
          name: BaseAudioName.longSun.fileName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.longSun.fileName),
    Sound(id: 2,
          name: BaseAudioName.spaceMid.fileName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.spaceMid.fileName),
    Sound(id: 3,
          name: BaseAudioName.spaceLow.fileName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.spaceLow.fileName),
    Sound(id: 4,
          name: BaseAudioName.spaceHigh.fileName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: BaseAudioName.spaceHigh.fileName),
    Sound(id: 5,
          name: BaseAudioName.oxygen.fileName,
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
          name: MelodyAudioName.ambient.fileName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.ambient.fileName),
    Sound(id: 12,
          name: MelodyAudioName.garden.fileName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.garden.fileName),
    Sound(id: 13,
          name: MelodyAudioName.gymnopedia.fileName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.gymnopedia.fileName),
    Sound(id: 14,
          name: MelodyAudioName.relaxing.fileName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: MelodyAudioName.relaxing.fileName),
    Sound(id: 15,
          name: MelodyAudioName.wisdom.fileName,
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
          name: NaturalAudioName.dryGrass.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.dryGrass.fileName),
    Sound(id: 22,
          name: NaturalAudioName.stream.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.stream.fileName),
    Sound(id: 23,
          name: NaturalAudioName.summerField.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.summerField.fileName),
    Sound(id: 24,
          name: NaturalAudioName.umbrellaRain.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.umbrellaRain.fileName),
    Sound(id: 25,
          name: NaturalAudioName.wave.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: NaturalAudioName.wave.fileName)
]

#warning("name need changed")
struct fresh : Identifiable {
    var id : Int
    var name : String
    var price : String // description
    var image : String
}

var freshitems = [
    fresh(id: 0, name: BaseAudioName.longSun.fileName, price: "chinese gong sound",image: "gong"),
    fresh(id: 1, name: "ocean_4", price: "ocean sound",image: "f2"),
    fresh(id: 2, name: "Test", price: "this is test",image: "f3")
]

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