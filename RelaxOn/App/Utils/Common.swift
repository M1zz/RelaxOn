//
//  Common.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/17.
//

/**
 Public 하게 쓰여지는 프로퍼티 & 함수 등
 */

import Foundation

/**
 오리지널 사운드 리스트
 */
let originalSounds = [
    OriginalSound(name: "물방울", filter: .waterDrop, imageName: "WaterDrop", defaultColor: "DCE8F5"),
    
    // TODO: 이미지 완성되면 imageName, defaultColor 수정 해야함
    OriginalSound(name: "싱잉볼", filter: .singingBowl, imageName: "Wind", defaultColor: "DCE8F5"),
    
    // TODO: 이미지 완성되면 imageName, defaultColor 수정 해야함
    OriginalSound(name: "새소리", filter: .bird, imageName: "Forest", defaultColor: "DCE8F5")
]

/**
 Bundle에 있는 mp3 파일 경로 불러오는 기능
 */
func getPathUrl(forResource: String, musicExtension: MusicExtension) -> URL? {
    Bundle.main.url(forResource: forResource, withExtension: musicExtension.rawValue) ?? nil
}

func getPathNSURL(forResource: String, musicExtension: MusicExtension) -> NSURL? {
    return Bundle.main.url(forResource: forResource, withExtension: musicExtension.rawValue) as NSURL?
}
