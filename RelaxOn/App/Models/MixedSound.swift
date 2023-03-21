//
//  FileInfo.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/10.
//

import Foundation

struct MixedSound: Identifiable, Codable, Equatable { // Hashable
    
    let id: UUID // UUID()
    var name: String
    var imgeName: String
    var audioVolume: Float
    var baseSound: Sound
    //TODO: 2개 이상을 구조로 묶어서?
    
    init(name: String, imgeName: String, audioVolume: Float, baseSound: Sound) {
        self.id = UUID()
        self.name = name
        self.imgeName = imgeName
        self.audioVolume = audioVolume
        self.baseSound = baseSound
    }
}

extension MixedSound {
    /// Equatable 프로토콜을 준수하기 위한 함수, 왼쪽(lhs)과 오른쪽(rhs) 값을 비교하여 동일한지 나타낸다.
    static func == (lhs: MixedSound, rhs: MixedSound) -> Bool {
        return true
    }
}
