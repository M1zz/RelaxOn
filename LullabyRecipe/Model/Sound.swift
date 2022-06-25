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
          name: BaseAudioName.chineseGong.fileName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: "gong1"),
    Sound(id: 2,
          name: BaseAudioName.gongNoHit.fileName,
          soundType: .base,
          audioVolume: 0.8,
          imageName: "gong2"),
]

var melodySounds = [
    Sound(id: 3,
          name: "Empty",
          soundType: .melody,
          audioVolume: 1.0,
          imageName: "music"),
    Sound(id: 4,
          name: MelodyAudioName.lynx.fileName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: "Melody1"),
    Sound(id: 5,
          name: MelodyAudioName.perlBird.fileName,
          soundType: .melody,
          audioVolume: 1.0,
          imageName: "Melody2"),
]

var naturalSounds = [
    Sound(id: 6,
          name: "Empty",
          soundType: .natural,
          audioVolume: 0.4,
          imageName: "music"),
    Sound(id: 7,
          name: NaturalAudioName.creekBabbling.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: "creek"),
    Sound(id: 8,
          name: NaturalAudioName.ocean4.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: "ocean"),
    Sound(id: 9,
          name: NaturalAudioName.waterDrip.fileName,
          soundType: .natural,
          audioVolume: 0.4,
          imageName: "waterdrip")
]

#warning("name need changed")
struct fresh : Identifiable {
    var id : Int
    var name : String
    var price : String // description
    var image : String
}

var freshitems = [
    fresh(id: 0, name: BaseAudioName.chineseGong.fileName, price: "chinese gong sound",image: "gong"),
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

let dummyMixedSound = MixedSound(id: 0,
                                 name: "test",
                                 baseSound: dummyBaseSound,
                                 melodySound: dummyMelodySound,
                                 naturalSound: dummyNaturalSound,
                                 imageName: "Recipe1")

let dummyBaseSound = Sound(id: 0,
                           name: BaseAudioName.chineseGong.fileName,
                           soundType: .base,
                           audioVolume: 0.8,
                           imageName: "gong1")

let dummyMelodySound = Sound(id: 2,
                             name: MelodyAudioName.lynx.fileName,
                             soundType: .melody,
                             audioVolume: 1.0,
                             imageName: "Melody1")

let dummyNaturalSound = Sound(id: 6,
                              name: NaturalAudioName.creekBabbling.fileName,
                              soundType: .natural,
                              audioVolume: 0.4,
                              imageName: "field")

