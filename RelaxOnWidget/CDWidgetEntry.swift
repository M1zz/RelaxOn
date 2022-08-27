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
    
    init(date: Date = Date(),
         baseImageName: String = BaseAudioName.longSun.fileName,
         melodyImageName: String = MelodyAudioName.ambient.fileName,
         whiteNoiseImageName: String = WhiteNoiseAudioName.dryGrass.fileName,
         id: Int = 100,
         name: String = "tempWidget") {
        self.date = date
        self.baseImageName = baseImageName
        self.melodyImageName = melodyImageName
        self.whiteNoiseImageName = whiteNoiseImageName
        self.id = id
        self.name = name
        self.url = WidgetManager.getURL(id: id)
    }
}

extension CDWidgetEntry {
    static var sample = CDWidgetEntry()
}
