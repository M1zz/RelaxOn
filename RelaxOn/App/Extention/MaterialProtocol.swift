//
//  MaterialProtocol.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/11/14.
//

import Foundation

protocol MaterialProtocol: RawRepresentable, CaseIterable where RawValue.Type == String.Type {
    var fileName: String { get }
    var displayName: String { get }
    static func materialList(type: MaterialType) -> [Material]
}

extension MaterialProtocol {
    var fileName: String {
        self.displayName.components(separatedBy: " ").joined()
    }
    
    var displayName: String {
        self.rawValue.addSpaceBeforeUppercase.convertUppercaseFirstChar
    }
    
    static func materialList(type: MaterialType) -> [Material] {
        self.allCases.enumerated().map {
            Material(id: $0.offset, name: $0.element.displayName, materialType: type, audioVolume: 0.5, fileName: $0.offset == 0 ? "" : $0.element.fileName)
        }
    }
}
