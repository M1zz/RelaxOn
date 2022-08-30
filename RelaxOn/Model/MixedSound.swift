//
//  MixedSound.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

struct MixedSound: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    var baseSound: Sound?
    var melodySound: Sound?
    var whiteNoiseSound: Sound?
    let fileName: String
    let url: URL?
    
    init(name: String, baseSound: Sound?, melodySound: Sound?, whiteNoiseSound: Sound?, fileName: String) {
        self.id = MixedSound.getUniqueId()
        self.name = name
        self.baseSound = baseSound
        self.melodySound = melodySound
        self.whiteNoiseSound = whiteNoiseSound
        self.fileName = fileName
        self.url = WidgetManager.getURL(id: id)
    }
}

extension MixedSound {
    static func == (lhs: MixedSound, rhs: MixedSound) -> Bool {
        return true
    }
    
    /// 마지막으로 생성된 id + 1 값을 반환
    static func getUniqueId() -> Int {
        let lastMusicId = UserDefaultsManager.shared.lastMusicId
        let returnId = lastMusicId + 1
        UserDefaultsManager.shared.lastMusicId = returnId
        return returnId
    }
}

let emptyMixedSound = MixedSound(name: "empty",
                                 baseSound: emptySound,
                                 melodySound: emptySound,
                                 whiteNoiseSound: emptySound,
                                 fileName: "")

