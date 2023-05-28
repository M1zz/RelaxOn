//
//  UserFileManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/29.
//

import Foundation
import SwiftUI
import AVFAudio

/**
 FileManager에 오디오 데이터를 파일로 저장 & 불러오기 & (파일이름)수정 & 파일 삭제 기능
 */
final class UserFileManager {
    
    static let shared = UserFileManager()
    private let fileManager = FileManager.default
    
    private var infoDirectoryURL: URL {
        return fileManager
            .urls(
                for: .documentDirectory,
                in: .userDomainMask
            )
            .first!
            .appendingPathComponent("relaxOn")
    }
    
    private var musicDirectoryURL: URL {
        return fileManager
            .urls(
                for: .musicDirectory,
                in: .userDomainMask
            )
            .first!
            .appendingPathComponent("relaxOn")
    }
    
    private var imageDirectoryURL: URL {
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
    
    func save(_ originalSound: OriginalSound, _ audioVariation: AudioVariation, _ fileName: String, _ color: Color, _ audioEngineManager: AudioEngineManager) {
        
        /// FileManager에 커스텀 오디오파일 저장
        saveAudio(audioEngineManager, fileName)
        
        /// FileManager에 커스텀 오디오 정보 JSON 저장
        saveJSON(originalSound, audioVariation, fileName)
        
        /// FileManager에 커스텀 이미지 저장
        saveImage(fileName, color, originalSound.category)
        
    }
    
}

// MARK: - About Audio File CRUD
extension UserFileManager {
    
    func saveAudio(_ audioEngineManager: AudioEngineManager, _ fileName: String) {
        guard let buffer = audioEngineManager.getAudioBuffer() else {
            print("Failed to get audio buffer")
            return
        }
        
        let fileURL = musicDirectoryURL.appendingPathComponent("\(fileName).\(MusicExtension.wav)")
        do {
            let audioFile = try AVAudioFile(forWriting: fileURL, settings: buffer.format.settings)
            try audioFile.write(from: buffer)
            print("Audio saved successfully.")
        } catch {
            print("Failed to save audio with error: \(error)")
        }
    }
    
    func loadAudio(_ fileName: String) -> AVAudioFile? {
        let fileURL = musicDirectoryURL.appendingPathComponent("\(fileName).\(MusicExtension.wav)")
        
        do {
            let audioFile = try AVAudioFile(forReading: fileURL)
            print("Audio loaded successfully.")
            return audioFile
        } catch {
            print("Failed to load audio with error: \(error)")
            return nil
        }
    }
    
    func modifyAudioName(currentName: String, newName: String) {
        let currentURL = musicDirectoryURL.appendingPathComponent("\(currentName).\(MusicExtension.wav)")
        let newURL = musicDirectoryURL.appendingPathComponent("\(newName).\(MusicExtension.wav)")
        
        do {
            try fileManager.moveItem(at: currentURL, to: newURL)
            print("Audio name modified successfully.")
        } catch {
            print("Failed to modify audio name with error: \(error)")
        }
    }
    
    func removeAudio(_ fileName: String) {
        let fileURL = musicDirectoryURL.appendingPathComponent("\(fileName).\(MusicExtension.wav)")
        
        do {
            try fileManager.removeItem(at: fileURL)
            print("Audio removed successfully.")
        } catch {
            print("Failed to remove audio with error: \(error)")
        }
    }
    
}

// MARK: - About JSON Info File CRUD
extension UserFileManager {
    
    func saveJSON(_ originalSound: OriginalSound, _ audioVariation: AudioVariation, _ fileName: String) {
        let customSound = CustomSound(
            fileName: fileName,
            category: originalSound.category,
            audioVariation: audioVariation,
            audioFilter: originalSound.filter
        )
        let fileURL = infoDirectoryURL.appendingPathComponent("\(fileName).\(FileExtension.json)")
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(customSound)
            try data.write(to: fileURL)
            print("JSON saved successfully.")
        } catch {
            print("Failed to save JSON with error: \(error)")
        }
    }
    
    func loadCustomSoundInfoFromJSON(fileName: String) -> CustomSound? {
        let fileURL = infoDirectoryURL.appendingPathComponent("\(fileName).\(FileExtension.json)")
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL)
            let customSound = try decoder.decode(CustomSound.self, from: data)
            return customSound
        } catch {
            print("Failed to load JSON with error: \(error)")
            return nil
        }
    }
    
    func modifyJSONName(oldFileName: String, newFileName: String) {
        let oldFileURL = infoDirectoryURL.appendingPathComponent("\(oldFileName).\(FileExtension.json)")
        let newFileURL = infoDirectoryURL.appendingPathComponent("\(newFileName).\(FileExtension.json)")
        do {
            try fileManager.moveItem(at: oldFileURL, to: newFileURL)
            print("JSON renamed successfully.")
        } catch {
            print("Failed to rename JSON with error: \(error)")
        }
    }

    func removeJSON(fileName: String) {
        let fileURL = infoDirectoryURL.appendingPathComponent("\(fileName).\(FileExtension.json)")
        do {
            try fileManager.removeItem(at: fileURL)
            print("JSON deleted successfully.")
        } catch {
            print("Failed to delete JSON with error: \(error)")
        }
    }
    
}

// MARK: - About Image File CRUD
extension UserFileManager {
    
    // FIXME: Image + BackgroundColor 파일로 저장하는 기능
    func saveImage(_ fileName: String, _ color: Color, _ category: SoundCategory) {
        if let image = UIImage(named: category.imageName) {
            let fileURL = imageDirectoryURL.appendingPathComponent("\(fileName).\(FileExtension.png)")
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
    
    func loadImage(fileName: String) -> UIImage {
        let fileURL = imageDirectoryURL.appendingPathComponent("\(fileName).\(FileExtension.png)")
        do {
            let imageData = try Data(contentsOf: fileURL)
            if let image = UIImage(data: imageData) {
                return image
            }
        } catch {
            print("Error loading image : \(error)")
        }
        return UIImage(systemName: "photo") ?? UIImage()
    }
    
    func modifyImageName(oldFileName: String, newFileName: String) {
        let oldFileURL = imageDirectoryURL.appendingPathComponent("\(oldFileName).\(FileExtension.png)")
        let newFileURL = imageDirectoryURL.appendingPathComponent("\(newFileName).\(FileExtension.png)")
        do {
            try fileManager.moveItem(at: oldFileURL, to: newFileURL)
            print("Image renamed successfully.")
        } catch {
            print("Failed to rename image with error: \(error)")
        }
    }

    func removeImage(fileName: String) {
        let fileURL = imageDirectoryURL.appendingPathComponent("\(fileName).\(FileExtension.png)")
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
