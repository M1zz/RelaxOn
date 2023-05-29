//
//  FileManager+Extension.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/29.
//

import Foundation

extension FileManager {
    
    func encode<T: Encodable>(data: T, to fileName: String, fileExtension: String = "json", directory: FileManager.SearchPathDirectory = .documentDirectory) {
        let encoder = JSONEncoder()
        
        guard let encodedData = try? encoder.encode(data) else {
            fatalError("[ERROR] \(fileName) 인코딩 실패")
        }
        
        let urls = self.urls(for: directory, in: .userDomainMask)
        
        if let url = urls.first?.appendingPathComponent("relaxOn") {
            do {
                if !fileExists(atPath: url.path) {
                    try createDirectory(at: url, withIntermediateDirectories: true)
                }
                let fileURL = url.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
                try encodedData.write(to: fileURL)
            } catch {
                fatalError("[ERROR] \(fileName) 저장 실패: \(error)")
            }
        } else {
            fatalError("[ERROR] \(fileName) 저장 경로를 찾을 수 없음")
        }
    }

    
    func decode<T: Decodable>(_ fileType: T.Type, from fileName: String, fileExtension: String = "json", directory: FileManager.SearchPathDirectory = .documentDirectory) -> T {
        let urls = self.urls(for: directory, in: .userDomainMask)
        
        guard let url = urls.first?.appendingPathComponent("relaxOn").appendingPathComponent(fileName).appendingPathExtension(fileExtension) else {
            fatalError("[ERROR] \(fileName) 로드 실패: 파일 경로를 찾을 수 없음")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("[ERROR] \(fileName) 로드 실패: 데이터를 불러올 수 없음")
        }
        
        let decoder = JSONDecoder()
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("[ERROR] \(fileName) 디코딩 실패")
        }
        
        return loadedData
    }

}
