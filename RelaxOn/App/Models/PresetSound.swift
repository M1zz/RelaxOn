//
//  PresetSound.swift
//  RelaxOn
//
//  Created by Claude on 2025/01/17.
//

import Foundation
import SwiftUI

/**
 미리 만들어진 프리셋 사운드
 사용자가 바로 사용할 수 있는 추천 사운드 조합
 */
struct PresetSound: Identifiable, Codable {
    let id: String
    let name: String
    let category: PresetCategory
    let description: String
    let icon: String
    let color: String
    let layers: [PresetLayer]
    let backgroundSound: String?
    let backgroundVolume: Float?

    struct PresetLayer: Codable {
        let filter: AudioFilter
        let category: SoundCategory
        let volume: Float
        let pitch: Float
        let interval: Float
        let intervalVariation: Float
        let volumeVariation: Float
        let pitchVariation: Float
    }

    /// 로컬라이제이션된 이름
    var localizedName: String {
        switch id {
        case "deep-sleep": return L.PresetNew.DeepSleep.name.localized
        case "rain-sleep": return L.PresetNew.RainSleep.name.localized
        case "white-noise-sleep": return L.PresetNew.WhiteNoiseSleep.name.localized
        case "cafe-focus": return L.PresetNew.CafeFocus.name.localized
        case "deep-focus": return L.PresetNew.DeepFocus.name.localized
        case "study-time": return L.PresetNew.StudyTime.name.localized
        case "meditation": return L.PresetNew.MeditationTime.name.localized
        case "yoga-stretch": return L.PresetNew.YogaStretching.name.localized
        case "forest-walk": return L.PresetNew.ForestWalk.name.localized
        case "cave-exploration": return L.PresetNew.CaveExplore.name.localized
        case "campfire": return L.Listen.campfire.localized
        case "rain": return L.Listen.rainSound.localized
        case "heavy-rain": return L.Listen.heavyRain.localized
        default: return name
        }
    }

    /// 로컬라이제이션된 설명
    var localizedDescription: String {
        switch id {
        case "deep-sleep": return L.PresetNew.DeepSleep.description.localized
        case "rain-sleep": return L.PresetNew.RainSleep.description.localized
        case "white-noise-sleep": return L.PresetNew.WhiteNoiseSleep.description.localized
        case "cafe-focus": return L.PresetNew.CafeFocus.description.localized
        case "deep-focus": return L.PresetNew.DeepFocus.description.localized
        case "study-time": return L.PresetNew.StudyTime.description.localized
        case "meditation": return L.PresetNew.MeditationTime.description.localized
        case "yoga-stretch": return L.PresetNew.YogaStretching.description.localized
        case "forest-walk": return L.PresetNew.ForestWalk.description.localized
        case "cave-exploration": return L.PresetNew.CaveExplore.description.localized
        case "campfire": return L.Listen.campfireDescription.localized
        case "rain": return L.Listen.rainSoundDescription.localized
        case "heavy-rain": return L.Listen.heavyRainDescription.localized
        default: return description
        }
    }
}

enum PresetCategory: String, CaseIterable, Codable {
    case sleep = "sleep"
    case focus = "focus"
    case meditation = "meditation"
    case nature = "nature"
    case rain = "rain"

    var displayName: String {
        switch self {
        case .sleep: return L.PresetCategory.sleep.localized
        case .focus: return L.PresetCategory.focus.localized
        case .meditation: return L.PresetCategory.meditation.localized
        case .nature: return L.PresetCategory.nature.localized
        case .rain: return L.PresetCategory.rain.localized
        }
    }

    var icon: String {
        switch self {
        case .sleep: return "moon.stars.fill"
        case .focus: return "brain.head.profile"
        case .meditation: return "leaf.fill"
        case .nature: return "tree.fill"
        case .rain: return "cloud.rain.fill"
        }
    }

    var color: Color {
        switch self {
        case .sleep: return Color(.PrimaryPurple)
        case .focus: return .orange
        case .meditation: return .green
        case .nature: return .brown
        case .rain: return .blue
        }
    }
}

// MARK: - Preset Data

extension PresetSound {
    static let allPresets: [PresetSound] = [
        // MARK: - 수면 카테고리

        PresetSound(
            id: "deep-sleep",
            name: "깊은 숙면",
            category: .sleep,
            description: "동굴의 잔잔한 울림과 물방울 소리로 깊은 수면을 유도합니다",
            icon: "moon.zzz.fill",
            color: "#8B7DC8",
            layers: [
                PresetLayer(
                    filter: .Cave,
                    category: .WaterDrop,
                    volume: 0.8,
                    pitch: -200,
                    interval: 1.5,
                    intervalVariation: 0.2,
                    volumeVariation: 0.1,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .WaterDrop,
                    category: .WaterDrop,
                    volume: 0.6,
                    pitch: 0,
                    interval: 2.0,
                    intervalVariation: 0.3,
                    volumeVariation: 0.15,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.piano.rawValue,
            backgroundVolume: 0.3
        ),

        PresetSound(
            id: "rain-sleep",
            name: "빗소리 수면",
            category: .sleep,
            description: "빗소리처럼 들리는 싱크대 소리와 반향음으로 편안한 휴식",
            icon: "cloud.drizzle.fill",
            color: "#5B9BD5",
            layers: [
                PresetLayer(
                    filter: .Sink,
                    category: .WaterDrop,
                    volume: 1.0,
                    pitch: 0,
                    interval: 0.5,
                    intervalVariation: 0.3,
                    volumeVariation: 0.2,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .Basement,
                    category: .WaterDrop,
                    volume: 0.7,
                    pitch: -100,
                    interval: 1.5,
                    intervalVariation: 0.2,
                    volumeVariation: 0.1,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.piano.rawValue,
            backgroundVolume: 0.25
        ),

        PresetSound(
            id: "white-noise-sleep",
            name: "화이트노이즈 수면",
            category: .sleep,
            description: "깊고 균일한 백색소음으로 방해받지 않는 수면",
            icon: "waveform",
            color: "#A9A9A9",
            layers: [
                PresetLayer(
                    filter: .Pipe,
                    category: .WaterDrop,
                    volume: 1.0,
                    pitch: 0,
                    interval: 1.5,
                    intervalVariation: 0.1,
                    volumeVariation: 0.05,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .Cave,
                    category: .WaterDrop,
                    volume: 0.6,
                    pitch: -300,
                    interval: 1.5,
                    intervalVariation: 0.2,
                    volumeVariation: 0.1,
                    pitchVariation: 0
                )
            ],
            backgroundSound: nil,
            backgroundVolume: nil
        ),

        // MARK: - 집중 카테고리

        PresetSound(
            id: "cafe-focus",
            name: "카페 집중",
            category: .focus,
            description: "카페 분위기 속에서 편안하게 집중하세요",
            icon: "cup.and.saucer.fill",
            color: "#D4A574",
            layers: [
                PresetLayer(
                    filter: .Bird,
                    category: .Bird,
                    volume: 0.4,
                    pitch: -500,
                    interval: 3.0,
                    intervalVariation: 1.0,
                    volumeVariation: 0.2,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.lofi.rawValue,
            backgroundVolume: 0.5
        ),

        PresetSound(
            id: "deep-focus",
            name: "깊은 집중",
            category: .focus,
            description: "부드러운 백색소음과 앰비언트로 몰입도를 높입니다",
            icon: "brain.head.profile",
            color: "#FF8C42",
            layers: [
                PresetLayer(
                    filter: .Pipe,
                    category: .WaterDrop,
                    volume: 0.7,
                    pitch: 0,
                    interval: 1.5,
                    intervalVariation: 0.1,
                    volumeVariation: 0.05,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.ambient.rawValue,
            backgroundVolume: 0.4
        ),

        PresetSound(
            id: "study-time",
            name: "공부 타임",
            category: .focus,
            description: "로파이 음악과 함께 공부하기 좋은 환경",
            icon: "book.fill",
            color: "#FFA07A",
            layers: [
                PresetLayer(
                    filter: .Cave,
                    category: .WaterDrop,
                    volume: 0.6,
                    pitch: -200,
                    interval: 1.5,
                    intervalVariation: 0.2,
                    volumeVariation: 0.1,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.lofi.rawValue,
            backgroundVolume: 0.6
        ),

        // MARK: - 명상 카테고리

        PresetSound(
            id: "meditation",
            name: "명상 시간",
            category: .meditation,
            description: "싱잉볼의 맑은 소리로 마음을 정화합니다",
            icon: "leaf.fill",
            color: "#90C695",
            layers: [
                PresetLayer(
                    filter: .SingingBowl,
                    category: .SingingBowl,
                    volume: 0.8,
                    pitch: 0,
                    interval: 4.0,
                    intervalVariation: 0.5,
                    volumeVariation: 0.1,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.meditation.rawValue,
            backgroundVolume: 0.4
        ),

        PresetSound(
            id: "yoga-stretch",
            name: "요가 & 스트레칭",
            category: .meditation,
            description: "물방울과 싱잉볼의 조화로 몸과 마음을 이완합니다",
            icon: "figure.yoga",
            color: "#7FBC8C",
            layers: [
                PresetLayer(
                    filter: .WaterDrop,
                    category: .WaterDrop,
                    volume: 0.5,
                    pitch: 0,
                    interval: 2.5,
                    intervalVariation: 0.5,
                    volumeVariation: 0.15,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .SingingBowl,
                    category: .SingingBowl,
                    volume: 0.6,
                    pitch: 0,
                    interval: 5.0,
                    intervalVariation: 1.0,
                    volumeVariation: 0.1,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.ambient.rawValue,
            backgroundVolume: 0.35
        ),

        // MARK: - 자연 카테고리

        PresetSound(
            id: "forest-walk",
            name: "숲속 산책",
            category: .nature,
            description: "새소리와 딱따구리 소리가 어우러진 자연의 소리",
            icon: "tree.fill",
            color: "#5D8A66",
            layers: [
                PresetLayer(
                    filter: .Bird,
                    category: .Bird,
                    volume: 0.7,
                    pitch: 0,
                    interval: 2.0,
                    intervalVariation: 1.0,
                    volumeVariation: 0.2,
                    pitchVariation: 100
                ),
                PresetLayer(
                    filter: .Owl,
                    category: .Bird,
                    volume: 0.3,
                    pitch: 0,
                    interval: 8.0,
                    intervalVariation: 2.0,
                    volumeVariation: 0.15,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .Woodpecker,
                    category: .Bird,
                    volume: 0.4,
                    pitch: 0,
                    interval: 4.0,
                    intervalVariation: 1.5,
                    volumeVariation: 0.2,
                    pitchVariation: 0
                )
            ],
            backgroundSound: nil,
            backgroundVolume: nil
        ),

        PresetSound(
            id: "cave-exploration",
            name: "동굴 탐험",
            category: .nature,
            description: "신비로운 동굴 속 물방울 소리",
            icon: "mountain.2.fill",
            color: "#6B5B95",
            layers: [
                PresetLayer(
                    filter: .Cave,
                    category: .WaterDrop,
                    volume: 0.9,
                    pitch: 0,
                    interval: 1.5,
                    intervalVariation: 0.2,
                    volumeVariation: 0.1,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .WaterDrop,
                    category: .WaterDrop,
                    volume: 0.7,
                    pitch: 200,
                    interval: 3.0,
                    intervalVariation: 0.8,
                    volumeVariation: 0.15,
                    pitchVariation: 100
                )
            ],
            backgroundSound: nil,
            backgroundVolume: nil
        ),

        PresetSound(
            id: "campfire",
            name: "캠프파이어",
            category: .nature,
            description: "모닥불과 부엉이 소리가 있는 야영의 밤",
            icon: "flame.fill",
            color: "#FF6F3C",
            layers: [
                PresetLayer(
                    filter: .Basement,
                    category: .WaterDrop,
                    volume: 0.6,
                    pitch: -400,
                    interval: 0.8,
                    intervalVariation: 0.3,
                    volumeVariation: 0.2,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .Owl,
                    category: .Bird,
                    volume: 0.4,
                    pitch: 0,
                    interval: 10.0,
                    intervalVariation: 3.0,
                    volumeVariation: 0.15,
                    pitchVariation: 0
                )
            ],
            backgroundSound: BackgroundSound.guitar.rawValue,
            backgroundVolume: 0.35
        ),

        // MARK: - 비/물 카테고리

        PresetSound(
            id: "rain",
            name: "빗소리",
            category: .rain,
            description: "편안한 빗소리로 마음을 진정시킵니다",
            icon: "cloud.rain.fill",
            color: "#4A90E2",
            layers: [
                PresetLayer(
                    filter: .Sink,
                    category: .WaterDrop,
                    volume: 1.0,
                    pitch: 0,
                    interval: 0.3,
                    intervalVariation: 0.2,
                    volumeVariation: 0.25,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .Basement,
                    category: .WaterDrop,
                    volume: 0.5,
                    pitch: -200,
                    interval: 1.5,
                    intervalVariation: 0.3,
                    volumeVariation: 0.15,
                    pitchVariation: 0
                )
            ],
            backgroundSound: nil,
            backgroundVolume: nil
        ),

        PresetSound(
            id: "heavy-rain",
            name: "폭우 & 천둥",
            category: .rain,
            description: "강한 빗소리와 천둥소리로 몰입감 있는 경험",
            icon: "cloud.bolt.rain.fill",
            color: "#2E5A88",
            layers: [
                PresetLayer(
                    filter: .Sink,
                    category: .WaterDrop,
                    volume: 1.0,
                    pitch: 0,
                    interval: 0.2,
                    intervalVariation: 0.15,
                    volumeVariation: 0.3,
                    pitchVariation: 0
                ),
                PresetLayer(
                    filter: .Pipe,
                    category: .WaterDrop,
                    volume: 0.8,
                    pitch: -600,
                    interval: 1.5,
                    intervalVariation: 0.5,
                    volumeVariation: 0.2,
                    pitchVariation: 0
                )
            ],
            backgroundSound: nil,
            backgroundVolume: nil
        )
    ]

    /// 카테고리별로 프리셋을 그룹화
    static func groupedByCategory() -> [PresetCategory: [PresetSound]] {
        Dictionary(grouping: allPresets, by: { $0.category })
    }

    /// PresetSound를 CustomSound로 변환
    func toCustomSound() -> CustomSound {
        let soundLayers = layers.map { layer in
            CustomSound.SoundLayer(
                category: layer.category,
                filter: layer.filter,
                audioVariation: AudioVariation(
                    volume: layer.volume,
                    pitch: layer.pitch,
                    interval: layer.interval,
                    intervalVariation: layer.intervalVariation,
                    volumeVariation: layer.volumeVariation,
                    pitchVariation: layer.pitchVariation
                )
            )
        }

        return CustomSound(
            title: localizedName,
            category: layers[0].category,
            variation: AudioVariation(
                volume: layers[0].volume,
                pitch: layers[0].pitch,
                interval: layers[0].interval,
                intervalVariation: layers[0].intervalVariation,
                volumeVariation: layers[0].volumeVariation,
                pitchVariation: layers[0].pitchVariation
            ),
            filter: layers[0].filter,
            color: color,
            backgroundSound: backgroundSound,
            backgroundVolume: backgroundVolume,
            soundLayers: soundLayers.count > 1 ? soundLayers : nil,
            isPreset: true
        )
    }
}
