//
//  MixedSound.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/10.
//

import Foundation

// TODO: ProcessedSound 로 이름 변경
// TODO: 내부 구조 변경
/**
 사용자가 커스텀한 사운드 정보를 저장하고 불러오기 위한 구조체
 */
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
