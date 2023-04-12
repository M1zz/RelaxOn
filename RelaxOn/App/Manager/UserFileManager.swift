//
//  UserFileManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/29.
//

import Foundation

enum UserFileManagerError: Error {
    case fileNotFound
}

final class UserFileManager {
    static let shared = UserFileManager()
    
    private let fileExtension = "json"
    private let fileManager = FileManager.default
    private var documentsDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private init() {}
    
    /// MixedSound 오브젝트를 앱의 문서 디렉터리에 JSON 파일로 저장합니다.
    /// - Parameter mixedSound: 저장할 MixedSound 오브젝트입니다.
    /// - Throws: 인코딩 또는 파일 쓰기에 실패한 경우 오류입니다.
    func saveMixedSound(_ mixedSound: MixedSound) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(mixedSound)
        let fileName = "\(mixedSound.id.uuidString).\(fileExtension)"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // 필요한 경우 중간 디렉터리를 생성합니다.
        try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        
        // 파일에 데이터 저장하기
        try data.write(to: fileURL)
        
        // UserDefaultsManager를 사용하여 MixedSound 정보 저장하기
        var mixedSounds = UserDefaultsManager.shared.mixedSounds
        mixedSounds.append(mixedSound)
        UserDefaultsManager.shared.mixedSounds = mixedSounds
    }
    
    /// 앱의 문서 디렉토리에서 MixedSound 오브젝트의 JSON 파일을 삭제합니다.
    /// - Parameter mixedSound: 삭제할 MixedSound 객체입니다.
    /// - Throws: 파일을 찾을 수 없거나 제거에 실패한 경우 오류입니다.
    func deleteMixedSound(_ mixedSound: MixedSound) throws {
        let fileName = "\(mixedSound.id.uuidString).\(fileExtension)"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // 파일 존재 여부 확인
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw UserFileManagerError.fileNotFound
        }
        
        // 파일 제거
        try fileManager.removeItem(at: fileURL)
    }
    
    /// 앱의 문서 디렉토리에서 모든 MixedSound 오브젝트를 로드합니다.
    /// - Returns: MixedSound 오브젝트의 배열입니다.
    /// - Throws: 디렉터리 읽기, 디코딩 또는 파일 로딩에 실패하면 오류가 발생합니다.
    func loadAllMixedSounds() throws -> [MixedSound] {
        let contents = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        let decoder = JSONDecoder()
        var mixedSounds: [MixedSound] = []
        
        for fileURL in contents {
            if fileURL.pathExtension == fileExtension {
                let data = try Data(contentsOf: fileURL)
                let mixedSound = try decoder.decode(MixedSound.self, from: data)
                mixedSounds.append(mixedSound)
            }
        }
        
        return mixedSounds
    }
}
