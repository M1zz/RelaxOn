//
//  Material.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import Foundation

struct Material: Identifiable, Codable, Equatable {
    let id: Int 
    let name: String
    var soundType: SoundType
    var audioVolume: Float
    let fileName: String
    
    static let empty: (SoundType) -> Sound = { type in
        Sound(id: 0,
              name: "Empty",
              soundType: type,
              audioVolume: 0.5,
              fileName: "")
    }
}
