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
        #warning("여기입니다")
        // FIXME: id가 고유한 값이 맞는지 물어봐야 합니다(누구 담당인지를 모르겠습니다 아시는 분 알려주세요 !) 의심스러워서 우선은 id + name을 주소값으로 넣었습니다
        if let url = URL(string: "RelaxOn:///\(id)+\(name)") {
            self.url = url
        } else {
            self.url = nil
        }
    }
}
