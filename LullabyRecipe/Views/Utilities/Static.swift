//
//  Static.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import Foundation

enum BaseAudioName {
    case chineseGong
    case gongNoHit
    
    var fileName: String {
        get {
            switch self {
            case .chineseGong:
                return "chinese_gong"
            case .gongNoHit:
                return "gong_nohit"
            }
        }
    }
}

enum MelodyAudioName {
    
    
}

enum NaturalAudioName {
    
    
}
