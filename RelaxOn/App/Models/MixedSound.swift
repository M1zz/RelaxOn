//
//  MixedSound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/10.
//

import Foundation

struct MixedSound: Identifiable, Codable {
    let id: UUID             // 생성된 MixedSound의 고유 아이디
    var name: String         // 생성된 MixedSound의 name
    var volume: Float        // 저장할 볼륨 값
    var imageName: String    // 저장할 이미지
    var audioFileURL: String // 저장된 오디오 파일의 URL
    
    init(name: String, volume: Float = 0.5, imageName: String = "placeholderImage", audioFileURL: String = "") {
        self.id = UUID()
        self.name = name
        self.volume = volume
        self.imageName = imageName
        self.audioFileURL = audioFileURL
    }
}
