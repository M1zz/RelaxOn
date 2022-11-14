//
//  Material.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import Foundation

struct Material: Identifiable, Codable, Equatable {
    #warning("name 없애기")
    let id: Int 
    let name: String
    var materialType: MaterialType
    var audioVolume: Float
    let fileName: String
    
    static let empty: (MaterialType) -> Material = { type in
        Material(id: 0, name: "Empty", materialType: type, audioVolume: 0.5, fileName: "")
    }
}
