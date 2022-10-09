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
    
    init(id: Int = MixedSound.getUniqueId(), name: String, baseSound: Sound?, melodySound: Sound?, whiteNoiseSound: Sound?, fileName: String) {
        self.id = id
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
        return lhs.id == rhs.id
    }
    
    /// 마지막으로 생성된 id + 1 값을 반환
    static func getUniqueId() -> Int {
        let lastMusicId = UserDefaultsManager.shared.lastMusicId
        let returnId = lastMusicId + 1
        UserDefaultsManager.shared.lastMusicId = returnId
        return returnId
    }
    
    static var empty: MixedSound {
        MixedSound(name: "Empty",
                   baseSound: Sound.empty(.base),
                   melodySound: Sound.empty(.melody),
                   whiteNoiseSound: Sound.empty(.whiteNoise),
                   fileName: "")
    }
    
    static var preview: MixedSound {
        MixedSound(name: "Preview",
                   baseSound: Sound.empty(.base),
                   melodySound: Sound.empty(.melody),
                   whiteNoiseSound: Sound.empty(.whiteNoise),
                   fileName: "Recipe1")
    }
    
    func getImageName() -> (String, String, String) {
        let baseImageName = baseSound?.fileName ?? ""
        let melodyImageName = melodySound?.fileName ?? ""
        let whiteNoiseImageName = whiteNoiseSound?.fileName ?? ""
        
        return (baseImageName, melodyImageName, whiteNoiseImageName)
    }
}

