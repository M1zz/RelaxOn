//
//  UserDefaultsManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/27.
//

import Foundation

/**
 UserDefaults에 사용자가 저장한 사운드 정보 & 온보딩 여부 & 마지막 재생 사운드 정보
 */
final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let standard = UserDefaults.standard
    // TODO: 앱 번들에 저장된 original sound file KEY
    private let MIXED_SOUND_KEY = UserDefaults.Keys.mixedSound
    // TODO: 온보딩 + 튜토리얼 여부 KEY
    // TODO: 마지막 재생 사운드 정보 KEY
}

// MARK: - Data Get, Set Properties
extension UserDefaultsManager {

    /// 유저가 저장한 MixedSounds 의 정보를 UserDefaults에 저장하기 위한 프로퍼티
    var mixedSounds: [MixedSound] {
        get {
            /// mixedSounds 조회시 저장된 데이터가 없다면 빈 배열 전달
            guard let data = standard.data(forKey: MIXED_SOUND_KEY) else { return [] }
            /// 파일이 존재한다면 JSONDecoder를 이용하여 디코딩하여 전달
            let decoder = JSONDecoder()
            /// 디코딩에 실패하면 빈 배열 전달
            return (try? decoder.decode([MixedSound].self, from: data)) ?? []
        }
        
        set {
            /// mixedSounds 저장할 때 JSONEncoder를 이용하여 인코딩 후 저장
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(newValue) {
                /// 인코딩에 성공하면 MIXED_SOUND_KEY 값으로 데이터 저장
                standard.set(encodedData, forKey: MIXED_SOUND_KEY)
            }
        }
    }
    
    func removeMixedSound(_ mixedSound: MixedSound) {
        var mixedSoundArray = mixedSounds
        /// 전달 받은 mixedSound의 id값과 동일한 mixedSound 삭제
        mixedSoundArray.removeAll { $0.id == mixedSound.id }
        mixedSounds = mixedSoundArray
    }
}
