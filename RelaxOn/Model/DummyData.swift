//
//  DummyData.swift
//  LullabyRecipe
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

let dummyMixedSound = MixedSound(id: 0,
                                 name: "test",
                                 baseSound: dummyBaseSound,
                                 melodySound: dummyMelodySound,
                                 naturalSound: dummyNaturalSound,
                                 imageName: "Recipe1")
let dummyBaseSound = Sound(id: 0,
                           name: BaseAudioName.longSun.fileName,
                           soundType: .base,
                           audioVolume: 0.8,
                           imageName: "LongSun")

let dummyMelodySound = Sound(id: 2,
                             name: MelodyAudioName.ambient.fileName,
                             soundType: .melody,
                             audioVolume: 1.0,
                             imageName: "Ambient")

let dummyNaturalSound = Sound(id: 6,
                              name: NaturalAudioName.dryGrass.fileName,
                              soundType: .natural,
                              audioVolume: 0.4,
                              imageName: "DryGrass")
