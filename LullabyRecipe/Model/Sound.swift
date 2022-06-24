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

// struct -> class
class MixedSound: Identifiable, Codable, Equatable {
    static func == (lhs: MixedSound, rhs: MixedSound) -> Bool {
        return true
    }
    
    let id: Int
    let name: String
    // var로 변경
    var baseSound: Sound?
    var melodySound: Sound?
    var naturalSound: Sound?
    let imageName: String
    
    // 코드 추가
    init(id: Int, name: String, baseSound: Sound?, melodySound: Sound?, naturalSound: Sound?, imageName: String) {
        self.id = id
        self.name = name
        self.baseSound = baseSound
        self.melodySound = melodySound
        self.naturalSound = naturalSound
        self.imageName = imageName
    }
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

let dummyMixedSound = MixedSound(id: 0,
                                 name: "test",
                                 baseSound: dummyBaseSound,
                                 melodySound: dummyMelodySound,
                                 naturalSound: dummyNaturalSound,
                                 imageName: "Recipe1")

let dummyBaseSound = Sound(id: 0,
                           name: BaseAudioName.longSun.fileName,
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

