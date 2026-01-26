//
//  SoundListView+Extension.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/25.
//

import Foundation

/// 전문가가 큐레이션한 프리셋 사운드 조합
struct Preset: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let category: SoundCategory
    let filter: AudioFilter
    let audioVariation: AudioVariation
    let color: String

    init(
        title: String,
        description: String,
        category: SoundCategory,
        filter: AudioFilter,
        audioVariation: AudioVariation,
        color: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.filter = filter
        self.audioVariation = audioVariation
        self.color = color ?? category.defaultColor
    }

    /// Preset을 OriginalSound로 변환
    func toOriginalSound() -> OriginalSound {
        return OriginalSound(
            name: title,
            filter: filter,
            category: category
        )
    }

    /// 전문가 큐레이션 프리셋 목록
    static let recommended: [Preset] = [
        // 수면 관련
        Preset(
            title: L.Preset.DeepSleep.title.localized,
            description: L.Preset.DeepSleep.description.localized,
            category: .WaterDrop,
            filter: .Cave,
            audioVariation: AudioVariation(volume: 0.6, pitch: -2.0, interval: 1.5),
            color: "B8D4E8"
        ),
        Preset(
            title: L.Preset.QuickSleep.title.localized,
            description: L.Preset.QuickSleep.description.localized,
            category: .SingingBowl,
            filter: .Empty,
            audioVariation: AudioVariation(volume: 0.5, pitch: 0.0, interval: 1.2),
            color: "F5C89B"
        ),

        // 휴식 관련
        Preset(
            title: L.Preset.Meditation.title.localized,
            description: L.Preset.Meditation.description.localized,
            category: .Bird,
            filter: .Forest,
            audioVariation: AudioVariation(volume: 0.5, pitch: -1.0, interval: 1.8),
            color: "9EC49A"
        ),
        Preset(
            title: L.Preset.Rest.title.localized,
            description: L.Preset.Rest.description.localized,
            category: .SingingBowl,
            filter: .SingingBowl,
            audioVariation: AudioVariation(volume: 0.4, pitch: -0.5, interval: 2.0),
            color: "FFD4A3"
        ),

        // 집중 관련
        Preset(
            title: L.Preset.Focus.title.localized,
            description: L.Preset.Focus.description.localized,
            category: .WaterDrop,
            filter: .WaterDrop,
            audioVariation: AudioVariation(volume: 0.7, pitch: 0.5, interval: 0.8),
            color: "D0E3F0"
        ),
        Preset(
            title: L.Preset.Reading.title.localized,
            description: L.Preset.Reading.description.localized,
            category: .Bird,
            filter: .Bird,
            audioVariation: AudioVariation(volume: 0.6, pitch: 0.0, interval: 1.0),
            color: "B5D8A7"
        ),

        // 자연의 소리
        Preset(
            title: L.Preset.Rain.title.localized,
            description: L.Preset.Rain.description.localized,
            category: .WaterDrop,
            filter: .Sink,
            audioVariation: AudioVariation(volume: 0.8, pitch: -1.5, interval: 0.6),
            color: "A8C8E0"
        ),
        Preset(
            title: L.Preset.ForestDawn.title.localized,
            description: L.Preset.ForestDawn.description.localized,
            category: .Bird,
            filter: .Cuckoo,
            audioVariation: AudioVariation(volume: 0.5, pitch: -0.5, interval: 1.5),
            color: "C8E6C9"
        )
    ]
}

extension SoundListView {

    /// 오리지널 사운드 리스트
    static let originalSounds = [
        OriginalSound(name: L.Category.waterdrop.localized, filter: .WaterDrop, category: .WaterDrop),

        // FIXME: 이미지 업데이트 후 수정
        OriginalSound(name: L.Category.singingBowl.localized, filter: .SingingBowl, category: .SingingBowl),

        // FIXME: 이미지 업데이트 후 수정
        OriginalSound(name: L.Category.bird.localized, filter: .Bird, category: .Bird)
    ]

}
