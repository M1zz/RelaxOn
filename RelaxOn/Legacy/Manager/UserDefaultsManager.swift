//
//  UserDefaultsManager.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private let standard = UserDefaults.standard
    
    private let RECIPES_KEY = "recipes"
    private let NOT_FIRST_VISIT_KEY = "notFirstVisit"
    private let LAST_MUSIC_ID_KEY = "lastMusicId"
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
