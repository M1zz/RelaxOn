//
//  Static.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI

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
    case perlBird
    case lynx
    
    var fileName: String {
        get {
            switch self {
            case .perlBird:
                return "perl_bird"
            case .lynx:
                return "lynx"
            }
        }
    }
}

enum NaturalAudioName {
    case creekBabbling
    case ocean4
    case waterDrip
    
    var fileName: String {
        get {
            switch self {
            case .creekBabbling:
                return "creek_babbling"
            case .ocean4:
                return "ocean_4"
            case .waterDrip:
                return "water_drip"
            }
        }
    }
}

enum ColorPalette {
    case background
    case forground
    case tabBackground
    case buttonBackground
    
    var color: Color {
        get {
            switch self {
            case .background:
                return Color("Background")
            case .forground:
                return Color("Forground")
            case .tabBackground:
                return Color("TabBackground")
            case .buttonBackground:
                return Color("ButtonBackground")
            }
        }
    }
}
