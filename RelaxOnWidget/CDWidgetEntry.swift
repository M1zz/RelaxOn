//
//  CDWidgetEntry.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/05.
//

import WidgetKit

struct CDWidgetEntry: TimelineEntry {
    let date: Date
    var url: URL?
    let isSample: Bool
    
    let data : SmallWidgetData
    
    init(date: Date = Date(),
         isSample: Bool = false,
         data: SmallWidgetData
    ) {
        self.date = date
        self.data = data
        self.url = WidgetManager.getURL(id: data.id)
        self.isSample = isSample
    }
}

extension CDWidgetEntry {
    static var sample = CDWidgetEntry(date: Date(), isSample: true, data: SmallWidgetData(baseImageName: BaseAudioName.longSun.fileName, melodyImageName: MelodyAudioName.ambient.fileName, whiteNoiseImageName: WhiteNoiseAudioName.dryGrass.fileName, name: "Listen to Music and Relax ON", id: 1, isPlaying: false, isRecentPlay: false))
}
