//
//  Errors.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/04/18.
//

import Foundation

enum UserFileManagerError: Error {
    case fileNotFound
}

enum MixedSoundError: Error {
    case fileSaveFailed
    case invalidData
    case decodingFailed
}
