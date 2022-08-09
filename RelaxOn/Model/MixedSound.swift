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
    
    /// 현재 라이브러리의 id 값에서 가장 큰 값에 + 1을 더한 값을 반환
    static func getUniqueId() -> Int {
        if let maxId = userRepositories.map({$0.id}).max() {
            return maxId + 1
        }
        return 0
    }

    let id: Int
    let name: String
    var baseSound: Sound?
    var melodySound: Sound?
    var naturalSound: Sound?
    let imageName: String
}
