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
    let description: String
    let imageName: String
}

struct MixedSound: Identifiable {
    let id: Int
    let name: String
    let sounds: [Sound]
    let description: String
    let imageName: String
}

var baseSounds = [
    Sound(id: 0, name: "선택하지 않음", description: "아무것도 선택하지 않습니다", imageName: "music"),
    Sound(id: 1, name: BaseAudioName.chineseGong.fileName, description: "chineseGong",imageName: "gong"),
    Sound(id: 2, name: BaseAudioName.gongNoHit.fileName, description: "gongNoHit",imageName: "p1"),
]

var melodySounds = [
    Sound(id: 3, name: "선택하지 않음", description: "아무것도 선택하지 않습니다", imageName: "music"),
    Sound(id: 4, name: MelodyAudioName.lynx.fileName, description: "lynx",imageName: "r1"),
    Sound(id: 5, name: MelodyAudioName.perlBird.fileName, description: "perlBird",imageName: "r2"),
]

var naturalSounds = [
    Sound(id: 6, name: "선택하지 않음", description: "아무것도 선택하지 않습니다", imageName: "music"),
    Sound(id: 7, name: NaturalAudioName.creekBabbling.fileName, description: "creekBabbling",imageName: "r3"),
    Sound(id: 8, name: NaturalAudioName.ocean4.fileName,description: "ocean4", imageName: "f1"),
    Sound(id: 9, name: NaturalAudioName.waterDrip.fileName, description: "waterDrip",imageName: "f3")
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
