//
//  Fresh.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import Foundation

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

struct Sound: Identifiable {
    let id: Int
    let name: String
    let description: String
    let imageName: String
}

var baseSounds = [
    Sound(id: 0, name: "chinese_gong", description: "chinese gong sound",imageName: "gong"),
    Sound(id: 1, name: "ocean_4", description: "ocean sound",imageName: "f2"),
    Sound(id: 2, name: "Test", description: "this is test",imageName: "f3")
]

var melodySounds = [
    Sound(id: 0, name: "chinese_gong", description: "chinese gong sound",imageName: "gong"),
    Sound(id: 1, name: "ocean_4", description: "ocean sound",imageName: "f2"),
    Sound(id: 2, name: "Test", description: "this is test",imageName: "f3")
]

var naturalSounds = [
    Sound(id: 0, name: "chinese_gong", description: "chinese gong sound",imageName: "gong"),
    Sound(id: 1, name: "ocean_4", description: "ocean sound",imageName: "f2"),
    Sound(id: 2, name: "Test", description: "this is test",imageName: "f3")
]
