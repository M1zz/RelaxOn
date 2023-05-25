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
    
    private let fileExtension = "json"
    private let fileManager = FileManager.default
    
    private var documentsDirectory: URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private init() {}
}

extension UserFileManager {
    // TODO: 오디오 데이터를 mp3 파일로 저장하는 기능
    
    // TODO: 특정 mp3 파일을 불러오는 기능
    
    // TODO: 저장된 파일의 이름 수정 기능
    
    // TODO: 저장된 파일 삭제 기능
}

// MARK: - 삭제 예정
extension UserFileManager {

    func saveMixedSound(_ mixedSound: MixedSound) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(mixedSound)
        let fileName = "\(mixedSound.id.uuidString).\(fileExtension)"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw MixedSoundError.fileSaveFailed
        }

        var mixedSounds = UserDefaultsManager.shared.mixedSounds
        mixedSounds.append(mixedSound)
        UserDefaultsManager.shared.mixedSounds = mixedSounds
    }

    func deleteMixedSound(_ mixedSound: MixedSound) throws {
        let fileName = "\(mixedSound.id.uuidString).\(fileExtension)"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw UserFileManagerError.fileNotFound
        }

        try fileManager.removeItem(at: fileURL)
    }

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
