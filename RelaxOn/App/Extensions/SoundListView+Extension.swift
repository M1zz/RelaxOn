//
//  SoundListView+Extension.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/25.
//

import Foundation

extension SoundListView {
    
    /// 오리지널 사운드 리스트
    static let originalSounds = [
        OriginalSound(name: "물소리", filter: .waterDrop, category: .waterDrop, defaultColor: "DCE8F5"),
        
        // TODO: 이미지 완성되면 imageName, defaultColor 수정 해야함
        OriginalSound(name: "싱잉볼", filter: .singingBowl, category: .singingBowl, defaultColor: "DCE8F5"),
        
        // TODO: 이미지 완성되면 imageName, defaultColor 수정 해야함
        OriginalSound(name: "새소리", filter: .bird, category: .bird, defaultColor: "DCE8F5")
    ]
    
}
