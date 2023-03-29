//
//  MixedSound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/10.
//

import Foundation

struct MixedSound: Hashable, Codable {
    let id: UUID            // 생성된 MixedSound의 고유 아이디
    var fileName: String    // 생성된 MixedSound의 fileName
    var volume: Float       // 저장할 볼륨 값
    var imageName: String   // 저장할 이미지
    
    init(fileName: String, volume: Float = 0.5, imageName: String = recipeRandomName.randomElement()!) {
        self.id = UUID()
        self.fileName = fileName
        self.volume = volume
        self.imageName = imageName
    }
}
