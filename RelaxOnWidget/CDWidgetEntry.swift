//
//  CDWidgetEntry.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/05.
//

import Foundation
import WidgetKit

struct CDWidgetEntry: TimelineEntry {
    // TimelineEntry 프로토콜은 date라는 프로퍼티를 필수적으로 요구함
    let date: Date // WidgetKit이 widget을 rendering할 date
    let data: MixedSound
    let audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float)
    
    #warning("title 없애기")
//    UserDefaults(suiteName: "group.widget.relaxOn")!.set("Recipe9", forKey: "imageName")
//    UserDefaults(suiteName: "group.widget.relaxOn")!.set("test4", forKey: "name")
//    UserDefaults(suiteName: "group.widget.relaxOn")!.set(3, forKey: "id")
    
    let imageName: String = UserDefaults(suiteName: "group.widget.relaxOn")!.value(forKey: "imageName") as? String ?? "imageName"
    let name: String = UserDefaults(suiteName: "group.widget.relaxOn")!.value(forKey: "name") as? String ?? "name"
    let id: Int = UserDefaults(suiteName: "group.widget.relaxOn")!.value(forKey: "id") as? Int ?? 0
    let title: String = UserDefaults(suiteName: "group.widget.relaxOn")!.value(forKey: "river") as? String ?? "DD"
}

extension CDWidgetEntry {
    static var sample = CDWidgetEntry(
        date: Date(),
        data: MixedSound(id: 0,
                         name: "sample",
                         baseSound: dummyBaseSound,
                         melodySound: dummyMelodySound,
                         naturalSound: dummyNaturalSound,
                         imageName: "Recipe1"),
        audioVolumes: (baseVolume: 5, melodyVolume: 5, naturalVolume: 5)
    )
    static var sample1 = CDWidgetEntry(
        date: Date(),
        data: MixedSound(id: 1,
                         name: "sample1",
                         baseSound: dummyBaseSound,
                         melodySound: dummyMelodySound,
                         naturalSound: dummyNaturalSound,
                         imageName: "Recipe1"),
        audioVolumes: (baseVolume: 5, melodyVolume: 5, naturalVolume: 5)
    )
    static var sample2 = CDWidgetEntry(
        date: Date(),
        data: MixedSound(id: 2,
                         name: "sample2",
                         baseSound: dummyBaseSound,
                         melodySound: dummyMelodySound,
                         naturalSound: dummyNaturalSound,
                         imageName: "Recipe1"),
        audioVolumes: (baseVolume: 5, melodyVolume: 5, naturalVolume: 5)
    )
    static var sample3 = CDWidgetEntry(
        date: Date(),
        data: MixedSound(id: 3,
                         name: "sample3",
                         baseSound: dummyBaseSound,
                         melodySound: dummyMelodySound,
                         naturalSound: dummyNaturalSound,
                         imageName: "Recipe1"),
        audioVolumes: (baseVolume: 5, melodyVolume: 5, naturalVolume: 5)
    )
    static var sample4 = CDWidgetEntry(
        date: Date(),
        data: MixedSound(id: 4,
                         name: "sample4",
                         baseSound: dummyBaseSound,
                         melodySound: dummyMelodySound,
                         naturalSound: dummyNaturalSound,
                         imageName: "Recipe1"),
        audioVolumes: (baseVolume: 5, melodyVolume: 5, naturalVolume: 5)
    )
}
