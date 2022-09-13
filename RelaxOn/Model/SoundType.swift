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
        var soundList = [Sound.empty(self.index)]
        switch self {
        case .base:
            soundList.append(contentsOf: BaseSound.soundList)
        case .melody:
            soundList.append(contentsOf: MelodySound.soundList)
        case .whiteNoise:
            soundList.append(contentsOf: WhiteNoiseSound.soundList)
        }
        return soundList
    }
    
    var index: Int {
        switch self {
        case .base:
            return 0
        case .melody:
            return 1
        case .whiteNoise:
            return 2
        }
    }
}

enum BaseSound: String, CaseIterable {
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
            Sound(id: $0.offset + 1,
                  name: $0.element.displayName,
                  soundType: .base,
                  audioVolume: 0.8,
                  fileName: $0.element.fileName)
        }
    }
}

enum MelodySound: String, CaseIterable {
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
            Sound(id: $0.offset + 1 + 10,
                  name: $0.element.displayName,
                  soundType: .base,
                  audioVolume: 0.8,
                  fileName: $0.element.fileName)
        }
    }
}

enum WhiteNoiseSound: String, CaseIterable {
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
            Sound(id: $0.offset + 1 + 20,
                  name: $0.element.displayName,
                  soundType: .base,
                  audioVolume: 0.8,
                  fileName: $0.element.fileName)
        }
    }
}
