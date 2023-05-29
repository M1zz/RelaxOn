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
