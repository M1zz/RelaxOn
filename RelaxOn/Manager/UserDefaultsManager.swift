//
//  UserDefaultsManager.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    let standard = UserDefaults.standard
    
    let RECIPES_KEY: String = "recipes"
    let NOT_FIRST_VISIT_KEY: String = "notFirstVisit"
    let LAST_MUSIC_ID_KEY: String = "lastMusicId"
}

/// Data Get, Set Properties
extension UserDefaultsManager {
    var recipes: Data? {
        get {
            return standard.data(forKey: RECIPES_KEY)
        }
        
        set {
            standard.set(newValue, forKey: RECIPES_KEY)
        }
    }
    
    var notFirstVisit: Bool {
        get {
            return standard.bool(forKey: NOT_FIRST_VISIT_KEY)
        }
        
        set {
            standard.set(newValue, forKey: NOT_FIRST_VISIT_KEY)
        }
    }
    
    var lastMusicId: Int {
        get {
            return standard.integer(forKey: LAST_MUSIC_ID_KEY)
        }
        
        set {
            standard.set(newValue, forKey: LAST_MUSIC_ID_KEY)
        }
    }
}
