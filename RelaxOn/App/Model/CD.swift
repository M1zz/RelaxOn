//
//  CD.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import Foundation

struct CD : Identifiable {
    let id: UUID = UUID()
    let name: String
    var base: Material?
    var melody: Material?
    var whiteNoise: Material?
//    let fileName: String
    let url: URL?
    
    init(name: String, base: Material? = nil, melody: Material? = nil, whiteNoise: Material? = nil, url: URL? = nil) {
        self.name = name
        self.base = base
        self.melody = melody
        self.whiteNoise = whiteNoise
        self.url = url
    }
    
    static let CDTempList = [
        CD(name: "리오"),
        CD(name: "다니"),
        CD(name: "리버")
    ]
}

extension CD: Equatable {
    static func == (lhs: CD, rhs: CD) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.base == rhs.base && lhs.melody == rhs.melody && lhs.whiteNoise == rhs.whiteNoise && lhs.url == rhs.url
    }
}

