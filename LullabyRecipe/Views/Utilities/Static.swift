//
//  Static.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI

enum BaseAudioName {
    case ChineseGong
    case GongNoHit
    case GongSmall
    
    var fileName: String {
        get {
            switch self {
            case .ChineseGong:
                return "ChineseGong"
            case .GongNoHit:
                return "GongNoHit"
            case .GongSmall:
                return "GongSmall"
            }
        }
    }
}

enum MelodyAudioName {
    case PrelBedCrystal
    case Lynx
    case DroneCrystal
    case LittleBee
    case LullabyForCharlie
    case RakingLeaves
    case SeemsLikeYesterday
    case WindChimes
    
    var fileName: String {
        get {
            switch self {
            case .PrelBedCrystal:
                return "PrelBedCrystal"
            case .Lynx:
                return "Lynx"
            case .DroneCrystal:
                return "DroneCrystal"
            case .LittleBee:
                return "LittleBee"
            case .LullabyForCharlie:
                return "LullabyForCharlie"
            case .RakingLeaves:
                return "RakingLeaves"
            case .SeemsLikeYesterday:
                return "SeemsLikeYesterday"
            case .WindChimes:
                return "WindChimes"
            }
        }
    }
}

enum NaturalAudioName {
    case CreekBabbling
    case WaterOceanSurf4
    case BaseWaterDrip
    case CornField
    case CreekSmall
    case NatureForestSwamp
    case RainLight4
    case RainUmbrella
    
    var fileName: String {
        get {
            switch self {
            case .CreekBabbling:
                return "CreekBabbling"
            case .WaterOceanSurf4:
                return "WaterOceanSurf4"
            case .BaseWaterDrip:
                return "BaseWaterDrip"
            case .CornField:
                return "CornField"
            case .CreekSmall:
                return "CreekSmall"
            case .NatureForestSwamp:
                return "NatureForestSwamp"
            case .RainLight4:
                return "RainLight4"
            case .RainUmbrella:
                return "RainUmbrella"
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
