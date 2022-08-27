//
//  CDWidgetEntry.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/05.
//

import WidgetKit

struct CDWidgetEntry: TimelineEntry {
    let date: Date
    
    let baseImageName: String
    let melodyImageName: String
    let whiteNoiseImageName: String
    var id: Int
    var name: String
    var url: URL?
    let isPlaying: Bool
    let isSample: Bool
    
    init(date: Date = Date(),
         baseImageName: String,
         melodyImageName: String,
         whiteNoiseImageName: String,
         id: Int,
         name: String,
         isPlaying: Bool,
         isSample: Bool = false) {
        self.date = date
        self.baseImageName = baseImageName
        self.melodyImageName = melodyImageName
        self.whiteNoiseImageName = whiteNoiseImageName
        self.id = id
        self.name = name
        self.url = WidgetManager.getURL(id: id)
        self.isPlaying = isPlaying
        self.isSample = isSample
    }
}

extension CDWidgetEntry {
    static var sample = CDWidgetEntry(date: Date(),
                                      baseImageName: BaseAudioName.longSun.fileName,
                                      melodyImageName: MelodyAudioName.ambient.fileName,
                                      whiteNoiseImageName: WhiteNoiseAudioName.dryGrass.fileName,
                                      id: 1,
                                      name: "Listen to Music and Relax ON",
                                      isPlaying: false, isSample: true)
}
