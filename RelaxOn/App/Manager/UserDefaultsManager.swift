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
    private let MIXED_SOUND_KEY = UserDefaults.Keys.mixedSound
    private let CUSTOM_SOUND_KEY = UserDefaults.Keys.customSound
}

// MARK: - Data Get, Set Properties
extension UserDefaultsManager {
    
    var customSounds: [CustomSound] {
        get {
            guard let customSoundsData = standard.data(forKey: CUSTOM_SOUND_KEY) else {
                return []
            }
            do {
                let decoder = JSONDecoder()
                let customSounds = try decoder.decode([CustomSound].self, from: customSoundsData)
                return customSounds
            } catch {
                print("Error decoding custom sounds: \(error)")
                return []
            }
        }
        
        set {
            do {
                let encoder = JSONEncoder()
                let customSoundsData = try encoder.encode(newValue)
                standard.set(customSoundsData, forKey: CUSTOM_SOUND_KEY)
            } catch {
                print("Error encoding custom sounds: \(error)")
            }
        }
    }
    
    func removeOneCustomSound(at index: Int) {
        var customSounds = self.customSounds
        customSounds.remove(at: index)
        self.customSounds = customSounds
    }
    
    func removeAllCustomSounds() {
        standard.removeObject(forKey: CUSTOM_SOUND_KEY)
    }
}

// MARK: - 삭제 예정
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
