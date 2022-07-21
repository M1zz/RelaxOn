//
//  UserDefaultsManager.swift
//  LullabyRecipe
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    let standard = UserDefaults.standard
    
    let userName: String = "userName"
    let guest: String = "Guest"
    let recipes: String = "recipes"
    let notFirstVisit: String = "notFirstVisit"
}
