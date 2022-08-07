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
    let name: String
    var baseSound: Sound?
    var melodySound: Sound?
    var naturalSound: Sound?
    let imageName: String
}

let emptyMixedSound = MixedSound(id: -1, name: "", imageName: "")
