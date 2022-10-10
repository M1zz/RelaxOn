//
//  SoundType.swift
//  RelaxOn
//
//  Created by Moon Jongseek on 2022/09/02.
//

import SwiftUI

enum SoundType: String, CaseIterable, Codable {
    case base
    case melody
    case whiteNoise
    
    var soundList: [Sound] {
        switch self {
        case .base: return BaseSound.soundList(type: self)
        case .melody: return MelodySound.soundList(type: self)
        case .whiteNoise: return WhiteNoiseSound.soundList(type: self)
        }
    }
}

enum BaseSound: String, SoundProtocol {
    case empty
    case longSun
    case spaceMid
    case spaceLow
    case spaceHigh
    case oxygen
}

enum MelodySound: String, SoundProtocol {
    case empty
    case ambient
    case garden
    case gymnopedie
    case relaxing
    case wisdom
}

enum WhiteNoiseSound: String, SoundProtocol {
    case empty
    case dryGrass
    case stream
    case summerField
    case umbrellaRain
    case wave
}
