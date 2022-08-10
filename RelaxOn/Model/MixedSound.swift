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
    
    /// 마지막으로 생성된 id + 1 값을 반환
    static func getUniqueId() -> Int {
        let lastMusicId = UserDefaultsManager.shared.standard.integer(forKey: UserDefaultsManager.shared.lastMusicId)
        let returnId = lastMusicId + 1
        UserDefaultsManager.shared.standard.set(returnId, forKey: UserDefaultsManager.shared.lastMusicId)
        return returnId
    }

    let id: Int
    let name: String
    var baseSound: Sound?
    var melodySound: Sound?
    var naturalSound: Sound?
    let imageName: String
    let url: URL?
    
    init(id: Int, name: String, baseSound: Sound?, melodySound: Sound?, naturalSound: Sound?, imageName: String) {
        self.id = id
        self.name = name
        self.baseSound = baseSound
        self.melodySound = melodySound
        self.naturalSound = naturalSound
        self.imageName = imageName
        self.url = WidgetManager.getURL(id: id)
    }
}
