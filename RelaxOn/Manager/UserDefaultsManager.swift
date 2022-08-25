//
//  UserDefaultsManager.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    let standard = UserDefaults.standard
    
    let recipes: String = "recipes"
    let notFirstVisit: String = "notFirstVisit"
    let lastMusicId: String = "lastMusicId"
}
