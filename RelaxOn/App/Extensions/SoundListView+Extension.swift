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
        OriginalSound(name: "물방울", filter: .WaterDrop, category: .WaterDrop),
        
        // FIXME: 이미지 업데이트 후 수정
        OriginalSound(name: "싱잉볼", filter: .SingingBowl, category: .SingingBowl),
        
        // FIXME: 이미지 업데이트 후 수정
        OriginalSound(name: "새소리", filter: .Bird, category: .Bird)
    ]
    
}
