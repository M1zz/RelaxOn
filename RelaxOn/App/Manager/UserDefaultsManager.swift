//
//  UserDefaultsManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/27.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let standard = UserDefaults.standard
    private let MIXED_SOUND_KEY = "mixedSound"
}

// MARK: - Data Get, Set Properties
extension UserDefaultsManager {
    var mixedSound: Data? {
        get {
            return standard.data(forKey: MIXED_SOUND_KEY)
        }
        
        set {
            standard.set(newValue, forKey: MIXED_SOUND_KEY)
        }
    }
}
