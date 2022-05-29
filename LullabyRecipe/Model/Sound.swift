//
//  Fresh.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import Foundation

struct Sound: Identifiable {
    let id: Int // = UUID()
    let name: String
    var audioVolume: Float? = 0.5
    let imageName: String
}

struct MixedSound: Identifiable {
    let id: Int
    let name: String
    let sounds: [Sound]
    let imageName: String
}

var baseSounds = [
    Sound(id: 0, name: "선택하지 않음", imageName: "music"),
    Sound(id: 1, name: BaseAudioName.chineseGong.fileName,imageName: "gong1"),
    Sound(id: 2, name: BaseAudioName.gongNoHit.fileName,imageName: "gong2"),
]

var melodySounds = [
    Sound(id: 3, name: "선택하지 않음", imageName: "music"),
    Sound(id: 4, name: MelodyAudioName.lynx.fileName, imageName: "Melody1"),
    Sound(id: 5, name: MelodyAudioName.perlBird.fileName, imageName: "Melody2"),
]

var naturalSounds = [
    Sound(id: 6, name: "선택하지 않음", imageName: "music"),
    Sound(id: 7, name: NaturalAudioName.creekBabbling.fileName, imageName: "creek"),
    Sound(id: 8, name: NaturalAudioName.ocean4.fileName, imageName: "ocean"),
    Sound(id: 9, name: NaturalAudioName.waterDrip.fileName, imageName: "waterdrip")
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
var userRepositories: [MixedSound] = [
    MixedSound(id: 0,
               name: "test",
               sounds: [Sound(id: 0,
                              name: BaseAudioName.chineseGong.fileName,
                              imageName: "gong1"),
                        
                        Sound(id: 2,
                              name: MelodyAudioName.lynx.fileName,
                              imageName: "Melody1"),
                        
                        Sound(id: 6,
                              name: NaturalAudioName.creekBabbling.fileName,
                              imageName: "r3")
               ],
               imageName: "Recipe1")
]
