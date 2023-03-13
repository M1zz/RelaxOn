//
//  MixedSound.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

struct OldMixedSound: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    var baseSound: OldSound?
    var melodySound: OldSound?
    var whiteNoiseSound: OldSound?
    let fileName: String
    let url: URL?
    
    init(id: Int = OldMixedSound.getUniqueId(), name: String, baseSound: OldSound?, melodySound: OldSound?, whiteNoiseSound: OldSound?, fileName: String) {
        self.id = id
        self.name = name
        self.baseSound = baseSound
        self.melodySound = melodySound
        self.whiteNoiseSound = whiteNoiseSound
        self.fileName = fileName
        self.url = WidgetManager.getURL(id: id)
    }
}

extension OldMixedSound {
    static func == (lhs: OldMixedSound, rhs: OldMixedSound) -> Bool {
        return true
    }
    
    /// 마지막으로 생성된 id + 1 값을 반환
    static func getUniqueId() -> Int {
        let lastMusicId = OldUserDefaultsManager.shared.lastMusicId
        let returnId = lastMusicId + 1
        OldUserDefaultsManager.shared.lastMusicId = returnId
        return returnId
    }
    
    static let preview = OldMixedSound(name: "Preview",
                                    baseSound: OldSound.empty(0, .base),
                                    melodySound: OldSound.empty(1, .melody),
                                    whiteNoiseSound: OldSound.empty(2, .whiteNoise),
                                    fileName: "Recipe1")
    
    func getImageName() -> (String, String, String) {
        let baseImageName = baseSound?.fileName ?? ""
        let melodyImageName = melodySound?.fileName ?? ""
        let whiteNoiseImageName = whiteNoiseSound?.fileName ?? ""
        
        return (baseImageName, melodyImageName, whiteNoiseImageName)
    }
}

let emptyMixedSound = OldMixedSound(name: "empty",
                                 baseSound: OldSound.empty(0, .base),
                                 melodySound: OldSound.empty(1, .melody),
                                 whiteNoiseSound: OldSound.empty(2, .whiteNoise),
                                 fileName: "")

