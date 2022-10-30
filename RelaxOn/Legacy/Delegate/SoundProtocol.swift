//
//  SoundProtocol.swift
//  RelaxOn
//
//  Created by Moon Jongseek on 2022/10/02.
//

import Foundation

protocol SoundProtocol: RawRepresentable, CaseIterable where RawValue.Type == String.Type {
    var fileName: String { get }
    var displayName: String { get }
    static func soundList(type: SoundType) -> [Sound]
}

extension SoundProtocol {
    var fileName: String {
        self.displayName.components(separatedBy: " ").joined()
    }
    
    var displayName: String {
        self.rawValue.addSpaceBeforeUppercase.convertUppercaseFirstChar
    }
    
    static func soundList(type: SoundType) -> [Sound] {
        self.allCases.enumerated().map {
            Sound(id: $0.offset,
                  name: $0.element.displayName,
                  soundType: type,
                  audioVolume: 0.5,
                  fileName: $0.offset == 0 ? "" : $0.element.fileName)
        }
    }
}
