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
    var audioVolume: Float? = 0.5
    let imageName: String
}

struct MixedSound: Identifiable, Codable {
    let id: Int
    let name: String
    let sounds: [Sound]
    let imageName: String
}

var baseSounds = [
    Sound(id: 0,
          name: "선택하지 않음",
          soundType: .base,
          imageName: "music"),
    Sound(id: 1,
          name: BaseAudioName.chineseGong.fileName,
          soundType: .base,
          imageName: "gong1"),
    Sound(id: 2,
          name: BaseAudioName.gongNoHit.fileName,
          soundType: .base,
          imageName: "gong2"),
]

var melodySounds = [
    Sound(id: 3,
          name: "선택하지 않음",
          soundType: .melody,
          imageName: "music"),
    Sound(id: 4,
          name: MelodyAudioName.lynx.fileName,
          soundType: .melody,
          imageName: "Melody1"),
    Sound(id: 5,
          name: MelodyAudioName.perlBird.fileName,
          soundType: .melody,
          imageName: "Melody2"),
]

var naturalSounds = [
    Sound(id: 6,
          name: "선택하지 않음",
          soundType: .natural,
          imageName: "music"),
    Sound(id: 7,
          name: NaturalAudioName.creekBabbling.fileName,
          soundType: .natural,
          imageName: "creek"),
    Sound(id: 8,
          name: NaturalAudioName.ocean4.fileName,
          soundType: .natural,
          imageName: "ocean"),
    Sound(id: 9,
          name: NaturalAudioName.waterDrip.fileName,
          soundType: .natural,
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

var mixedAudioSources: [Sound] = []
var userRepositories: [MixedSound] = [dummyMixedSound]

let dummyMixedSound = MixedSound(id: 0,
               name: "test",
               sounds: dummySounds,
               imageName: "Recipe1")


let dummySounds = [
    Sound(id: 0,
          name: BaseAudioName.chineseGong.fileName,
          soundType: .base,
          imageName: "gong1"),
    
    Sound(id: 2,
          name: MelodyAudioName.lynx.fileName,
          soundType: .melody,
          imageName: "Melody1"),
    
    Sound(id: 6,
          name: NaturalAudioName.creekBabbling.fileName,
          soundType: .natural,
          imageName: "r3")
]
