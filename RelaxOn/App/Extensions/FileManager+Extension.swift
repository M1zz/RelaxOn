//
//  FileManager+Extension.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/29.
//

import Foundation

extension FileManager {
    
    func encode<T: Encodable>(data: T, to fileName: String, directory: FileManager.SearchPathDirectory = .documentDirectory) -> Bool {
        let encoder = JSONEncoder()
        
        guard let encodedData = try? encoder.encode(data) else {
            print("[ERROR] \(fileName) 인코딩 실패")
            return false
        }
        
        let urls = self.urls(for: directory, in: .userDomainMask)
        
        if let url = urls.first?.appendingPathComponent("relaxOn") {
            do {
                if !fileExists(atPath: url.path) {
                    try createDirectory(at: url, withIntermediateDirectories: true)
                }
                let fileURL = url.appendingPathComponent(fileName).appendingPathExtension(FileExtension.json.rawValue)
                try encodedData.write(to: fileURL)
            } catch {
                print("[ERROR] \(fileName) 저장 실패: \(error)")
                return false
            }
        } else {
            print("[ERROR] \(fileName) 저장 경로를 찾을 수 없음")
            return false
        }
        return true
    }

    
    func decode<T: Decodable>(_ fileType: T.Type, from fileName: String, directory: FileManager.SearchPathDirectory = .documentDirectory) -> T? {
        let urls = self.urls(for: directory, in: .userDomainMask)
        
        guard let url = urls.first?.appendingPathComponent("relaxOn").appendingPathComponent(fileName).appendingPathExtension(FileExtension.json.rawValue) else {
            print("[ERROR] \(fileName) 로드 실패: 파일 경로를 찾을 수 없음")
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("[ERROR] \(fileName) 로드 실패: 데이터를 불러올 수 없음")
            return nil
        }
        
        let decoder = JSONDecoder()
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            print("[ERROR] \(fileName) 디코딩 실패")
            return nil
        }
        
        return loadedData
    }

}
