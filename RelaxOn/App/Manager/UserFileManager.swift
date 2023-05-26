//
//  UserFileManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/29.
//

import Foundation
import SwiftUI

/**
 FileManager에 오디오 데이터를 파일로 저장 & 불러오기 & (파일이름)수정 & 파일 삭제 기능
 */
final class UserFileManager {
    
    static let shared = UserFileManager()
    private let fileManager = FileManager.default
    
    private var infoDirectory: URL {
        return fileManager
            .urls(
                for: .documentDirectory,
                in: .userDomainMask
            )
            .first!
            .appendingPathComponent("relaxOn")
    }
    
    private var musicDirectory: URL {
        return fileManager
            .urls(
                for: .musicDirectory,
                in: .userDomainMask
            )
            .first!
            .appendingPathComponent("relaxOn")
    }
    
    private var imageDirectory: URL {
        return fileManager
            .urls(
                for: .documentDirectory,
                in: .userDomainMask
            )
            .first!
            .appendingPathComponent("relaxOn/Images")
    }
    
    private init() {}
}

// MARK: - CRUD
extension UserFileManager {
    
    func save(_ originalSound: OriginalSound, _ audioVariation: AudioVariation, _ fileName: String, _ color: Color) {
        
        // TODO: FileManager에 커스텀 오디오파일 저장
        saveAudio(originalSound, audioVariation, fileName)
        
        // TODO: FileManager에 커스텀 오디오 정보 JSON 저장
        saveJSON(originalSound, audioVariation, fileName)
        
        // TODO: FileManager에 커스텀 이미지 저장
        saveImage(fileName, color, originalSound.category)
        
    }
    
}

// MARK: - About Audio File CRUD
extension UserFileManager {
    
    // TODO: 오디오 데이터를 mp3 파일로 저장하는 기능
    func saveAudio(_ originalSound: OriginalSound, _ audioVariation: AudioVariation, _ fileName: String) {
        
    }
    
    // TODO: 특정 mp3 파일을 불러오는 기능
    
    
    // TODO: 저장된 파일의 이름 수정 기능
    
    
    // TODO: 저장된 파일 삭제 기능
    
    
}

// MARK: - About JSON Info File CRUD
extension UserFileManager {
    
    // TODO: 오디오 데이터를 JSON 파일로 저장하는 기능
    func saveJSON(_ originalSound: OriginalSound, _ audioVariation: AudioVariation, _ fileName: String) {
        
    }
    
    // TODO: 특정 JSON 파일을 불러오는 기능
    
    
    // TODO: 저장된 JSON 파일의 이름 수정 기능
    
    
    // TODO: 저장된 JSON 파일 삭제 기능
    
    
}

// MARK: - About Image File CRUD
extension UserFileManager {
    
    // FIXME: Image + BackgroundColor 파일로 저장하는 기능
    func saveImage(_ fileName: String, _ color: Color, _ category: SoundCategory) {
        if let image = UIImage(named: category.imageName) {
            let fileURL = imageDirectory.appendingPathComponent("\(fileName).png")
            if let pngData = image.pngData() {
                do {
                    try pngData.write(to: fileURL)
                    print("Image saved successfully.")
                } catch {
                    print("Failed to save image with error: \(error)")
                }
            }
            
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        let fileURL = imageDirectory.appendingPathComponent("\(fileName).png")
        guard let data = try? Data(contentsOf: fileURL) else {
            print("Failed to load image with name: \(fileName)")
            return nil
        }
        return UIImage(data: data)
    }
    
    func modifyImageName(oldFileName: String, newFileName: String) {
        let oldFileURL = imageDirectory.appendingPathComponent("\(oldFileName).png")
        let newFileURL = imageDirectory.appendingPathComponent("\(newFileName).png")
        do {
            try fileManager.moveItem(at: oldFileURL, to: newFileURL)
            print("Image renamed successfully.")
        } catch {
            print("Failed to rename image with error: \(error)")
        }
    }

    func removeImage(fileName: String) {
        let fileURL = imageDirectory.appendingPathComponent("\(fileName).png")
        do {
            try fileManager.removeItem(at: fileURL)
            print("Image deleted successfully.")
        } catch {
            print("Failed to delete image with error: \(error)")
        }
    }
    
}

// MARK: - 삭제 예정
extension UserFileManager {
    
    func saveMixedSound(_ mixedSound: MixedSound) throws {
        //        let encoder = JSONEncoder()
        //        let data = try encoder.encode(mixedSound)
        //        let fileName = "\(mixedSound.id.uuidString).\(FileExtension.json)"
        //        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        //        try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        
        //        do {
        //            try data.write(to: fileURL)
        //        } catch {
        //            throw MixedSoundError.fileSaveFailed
        //        }
        //
        //        var mixedSounds = UserDefaultsManager.shared.mixedSounds
        //        mixedSounds.append(mixedSound)
        //        UserDefaultsManager.shared.mixedSounds = mixedSounds
    }
    
    func deleteMixedSound(_ mixedSound: MixedSound) throws {
        //        let fileName = "\(mixedSound.id.uuidString).\(FileExtension.json)"
        //        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        //        guard fileManager.fileExists(atPath: fileURL.path) else {
        //            throw UserFileManagerError.fileNotFound
        //        }
        //
        //        try fileManager.removeItem(at: fileURL)
    }
    
    func loadAllMixedSounds() throws -> [MixedSound] {
        //        let contents = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        //        let decoder = JSONDecoder()
        //        var mixedSounds: [MixedSound] = []
        //
        //        for fileURL in contents {
        //            if fileURL.pathExtension == FileExtension.json.rawValue {
        //                let data = try Data(contentsOf: fileURL)
        //                let mixedSound = try decoder.decode(MixedSound.self, from: data)
        //                mixedSounds.append(mixedSound)
        //            }
        //        }
        return [MixedSound]()
    }
    
}
