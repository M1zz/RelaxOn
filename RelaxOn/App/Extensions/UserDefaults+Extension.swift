//
//  UserDefaults+Extension.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/04/18.
//

import Foundation

/**
 UserDefaults에 저장하는 Key 값 Extension
 */
extension UserDefaults {
    struct Keys {
        // TODO: mixedSound -> ProcessedSound 로 변경
        static let mixedSound = "mixedSound"
        // TODO: 온보딩 + 튜토리얼 여부 KEY
        // TODO: 마지막 재생 사운드 정보 KEY
    }
}
