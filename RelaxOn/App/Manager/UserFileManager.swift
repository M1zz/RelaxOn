//
//  UserFileManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/29.
//

import Foundation

/**
 FileManager에 오디오 데이터를 파일로 저장 & 불러오기 & (파일이름)수정 & 파일 삭제 기능
 */
final class UserFileManager {
    static let shared = UserFileManager()
    private let fileManager = FileManager.default
    private init() {}
}

extension UserFileManager {
    
    func saveToJSONFile(_ customSound: CustomSound) -> Bool {
        print(#function)
        
        if fileManager.encode(data: customSound, to: customSound.title) {
            return true
        }
        return false
    }
    
}
