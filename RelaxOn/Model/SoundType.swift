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
    
    static let soundList: (SoundType) -> [Sound] = { type in
        switch type {
        case .base: return BaseSound.soundList
        case .melody: return MelodySound.soundList
        case .whiteNoise: return WhiteNoiseSound.soundList
        }
    }
}

enum BaseSound: String, CaseIterable {
    case empty
    case longSun
    case spaceMid
    case spaceLow
    case spaceHigh
    case oxygen
    
    var fileName: String {
        return self.displayName.components(separatedBy: " ").joined()
    }
    
    var displayName: String {
        self.rawValue.addSpaceBeforeUppercase.convertUppercaseFirstChar
    }
    
    static var soundList: [Sound] {
        return self.allCases.enumerated().map {
            Sound(id: $0.offset,
                  name: $0.element.displayName,
                  soundType: .base,
                  audioVolume: 0.5,
                  fileName: $0.element.fileName)
        }
    }
}

enum MelodySound: String, CaseIterable {
    case empty
    case ambient
    case garden
    case gymnopedie
    case relaxing
    case wisdom
    
    var fileName: String {
        return self.displayName.components(separatedBy: " ").joined()
    }
    
    var displayName: String {
        self.rawValue.addSpaceBeforeUppercase.convertUppercaseFirstChar
    }
    
    static var soundList: [Sound] {
        return self.allCases.enumerated().map {
            Sound(id: $0.offset,
                  name: $0.element.displayName,
                  soundType: .melody,
                  audioVolume: 0.5,
                  fileName: $0.element.fileName)
        }
    }
}

enum WhiteNoiseSound: String, CaseIterable {
    case empty
    case dryGrass
    case stream
    case summerField
    case umbrellaRain
    case wave
    
    var fileName: String {
        return self.displayName.components(separatedBy: " ").joined()
    }
    
    var displayName: String {
        self.rawValue.addSpaceBeforeUppercase.convertUppercaseFirstChar
    }
    
    static var soundList: [Sound] {
        return self.allCases.enumerated().map {
            Sound(id: $0.offset,
                  name: $0.element.displayName,
                  soundType: .whiteNoise,
                  audioVolume: 0.5,
                  fileName: $0.element.fileName)
        }
    }
}
