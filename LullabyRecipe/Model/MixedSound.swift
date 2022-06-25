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
    let baseSound: Sound?
    let melodySound: Sound?
    let naturalSound: Sound?
    let imageName: String
}
