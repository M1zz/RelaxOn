//
//  MixedSound.swift
//  LullabyRecipe
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

struct MixedSound: Identifiable, Codable, Equatable {
    static func == (lhs: MixedSound, rhs: MixedSound) -> Bool {
        return true
    }
    
    let id: Int
    var name: String
    var baseSound: Sound?
    var melodySound: Sound?
    var naturalSound: Sound?
    let imageName: String
    let url: URL
    
    init(id: Int, name: String, baseSound: Sound?, melodySound: Sound?, naturalSound: Sound?, imageName: String) {
        self.id = id
        self.name = name
        self.baseSound = baseSound
        self.melodySound = melodySound
        self.naturalSound = naturalSound
        self.imageName = imageName
        #warning("id가 고유한 값 맞겠지..?")
        url =  URL(string: "RelaxOn:///\(id)+\(name)")!
        print("url임듕", url)
    }
}
