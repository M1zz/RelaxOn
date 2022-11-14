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
    
    enum KeyString {
        static let recipes = "recipes"
        static let notFirstVisit = "notFirstVisit"
        static let lastMusicId = "lastMusicId"
    }
}

/// Data Get, Set Properties
extension UserDefaultsManager {
    // TODO: 데이터 저장하고 값 가져오는 구조 고민해보기
#warning("recipes -> CDList로 변경하기")
    func updateCDList(_ CDList: [CD]) -> [CD] {
        let data = getEncodedData(data: CDList)
        standard.set(data, forKey: KeyString.recipes)
        
        return getCDList()
    }
    
    func getCDList() -> [CD] {
        if let data = standard.data(forKey: KeyString.recipes) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode([CD].self, from: data)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
        return []
    }
    
    var notFirstVisit: Bool {
        get {
            return standard.bool(forKey: KeyString.notFirstVisit)
        }
        
        set {
            standard.set(newValue, forKey: KeyString.notFirstVisit)
        }
    }
    
    var lastMusicId: Int {
        get {
            return standard.integer(forKey: KeyString.lastMusicId)
        }
        
        set {
            standard.set(newValue, forKey: KeyString.lastMusicId)
        }
    }
    
    private func getEncodedData(data: [CD]) -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            return encodedData
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        return nil
    }
}
