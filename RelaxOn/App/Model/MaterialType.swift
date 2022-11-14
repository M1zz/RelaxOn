//
//  MaterialType.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/11/14.
//

import SwiftUI

enum MaterialType: String, CaseIterable, Codable {
    case base
    case melody
    case whiteNoise
    
    var materialList: [Material] {
        switch self {
        case .base: return Base.materialList(type: self)
        case .melody: return Melody.materialList(type: self)
        case .whiteNoise: return WhiteNoise.materialList(type: self)
        }
    }
    
    func capitalName(materialType: MaterialType) -> String {
        return materialType.rawValue.capitalized
    }
}

enum Base: String, MaterialProtocol {
    
    case empty
    case longSun
    case spaceMid
    case spaceLow
    case spaceHigh
    case oxygen
}

enum Melody: String, MaterialProtocol {
    case empty
    case ambient
    case garden
    case gymnopedie
    case relaxing
    case wisdom
}

enum WhiteNoise: String, MaterialProtocol {
    case empty
    case dryGrass
    case stream
    case summerField
    case umbrellaRain
    case wave
}
