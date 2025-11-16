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
            title: "깊은 수면",
            description: "편안한 물방울 소리로 깊은 잠에 빠져보세요",
            category: .WaterDrop,
            filter: .Cave,
            audioVariation: AudioVariation(volume: 0.6, pitch: -2.0, interval: 1.5),
            color: "B8D4E8"
        ),
        Preset(
            title: "빠른 수면",
            description: "싱잉볼의 울림으로 마음을 차분하게",
            category: .SingingBowl,
            filter: .Empty,
            audioVariation: AudioVariation(volume: 0.5, pitch: 0.0, interval: 1.2),
            color: "F5C89B"
        ),

        // 휴식 관련
        Preset(
            title: "명상",
            description: "자연의 새소리와 함께하는 명상 시간",
            category: .Bird,
            filter: .Forest,
            audioVariation: AudioVariation(volume: 0.5, pitch: -1.0, interval: 1.8),
            color: "9EC49A"
        ),
        Preset(
            title: "휴식",
            description: "부드러운 싱잉볼 소리로 완벽한 휴식",
            category: .SingingBowl,
            filter: .SingingBowl,
            audioVariation: AudioVariation(volume: 0.4, pitch: -0.5, interval: 2.0),
            color: "FFD4A3"
        ),

        // 집중 관련
        Preset(
            title: "집중력 향상",
            description: "규칙적인 물방울 소리로 집중력 극대화",
            category: .WaterDrop,
            filter: .WaterDrop,
            audioVariation: AudioVariation(volume: 0.7, pitch: 0.5, interval: 0.8),
            color: "D0E3F0"
        ),
        Preset(
            title: "독서",
            description: "잔잔한 새소리와 함께하는 독서 시간",
            category: .Bird,
            filter: .Bird,
            audioVariation: AudioVariation(volume: 0.6, pitch: 0.0, interval: 1.0),
            color: "B5D8A7"
        ),

        // 자연의 소리
        Preset(
            title: "빗소리",
            description: "차분한 빗소리처럼 들리는 물방울",
            category: .WaterDrop,
            filter: .Sink,
            audioVariation: AudioVariation(volume: 0.8, pitch: -1.5, interval: 0.6),
            color: "A8C8E0"
        ),
        Preset(
            title: "숲속 새벽",
            description: "새벽 숲속의 고요함과 새소리",
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
        OriginalSound(name: "물방울", filter: .WaterDrop, category: .WaterDrop),

        // FIXME: 이미지 업데이트 후 수정
        OriginalSound(name: "싱잉볼", filter: .SingingBowl, category: .SingingBowl),

        // FIXME: 이미지 업데이트 후 수정
        OriginalSound(name: "새소리", filter: .Bird, category: .Bird)
    ]

}
