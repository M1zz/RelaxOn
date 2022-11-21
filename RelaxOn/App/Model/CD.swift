//
//  CD.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import Foundation

struct CD: Identifiable, Codable {
    let id: Int
    let name: String
    var base: Material?
    var melody: Material?
    var whiteNoise: Material?
//    let fileName: String
    
    init(id: Int = MixedSound.getUniqueId(), name: String, base: Material? = nil, melody: Material? = nil, whiteNoise: Material? = nil) {
        self.id = id
        self.name = name
        self.base = base
        self.melody = melody
        self.whiteNoise = whiteNoise
    }
    
    static let CDTempList = [
        CD(id: 0, name: "리오", base: Material(id: 0, name: Base.oxygen.rawValue, materialType: .base, audioVolume: 0.8, fileName: Base.oxygen.fileName),
           melody: Material(id: 1, name: Melody.garden.rawValue, materialType: .melody, audioVolume: 0.2, fileName: Melody.garden.fileName),
           whiteNoise: Material(id: 2, name: WhiteNoise.dryGrass.rawValue, materialType: .whiteNoise, audioVolume: 0.5, fileName: WhiteNoise.dryGrass.fileName)),
        
        CD(id: 1, name: "다니", base: Material(id: 0, name: Base.spaceMid.rawValue, materialType: .base, audioVolume: 0.8, fileName: Base.spaceMid.fileName),
           melody: Material(id: 1, name: Melody.ambient.rawValue, materialType: .melody, audioVolume: 0.2, fileName: Melody.ambient.fileName),
           whiteNoise: Material(id: 2, name: WhiteNoise.wave.rawValue, materialType: .whiteNoise, audioVolume: 0.5, fileName: WhiteNoise.wave.fileName)),

        CD(id: 2, name: "리버", base: Material(id: 0, name: Base.spaceHigh.rawValue, materialType: .base, audioVolume: 0.8, fileName: Base.spaceHigh.fileName),
           melody: Material(id: 1, name: Melody.relaxing.rawValue, materialType: .melody, audioVolume: 0.2, fileName: Melody.relaxing.fileName),
           whiteNoise: Material(id: 2, name: WhiteNoise.umbrellaRain.rawValue, materialType: .whiteNoise, audioVolume: 0.5, fileName: WhiteNoise.umbrellaRain.fileName))
    ]
}

extension CD: Equatable {
    static func == (lhs: CD, rhs: CD) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.base == rhs.base && lhs.melody == rhs.melody && lhs.whiteNoise == rhs.whiteNoise
    }
    
    /// 마지막으로 생성된 id + 1 값을 반환
    static func getUniqueId() -> Int {
        let lastMusicId = UserDefaultsManager.shared.lastMusicId
        let returnId = lastMusicId + 1
        UserDefaultsManager.shared.lastMusicId = returnId
        return returnId
    }
}
