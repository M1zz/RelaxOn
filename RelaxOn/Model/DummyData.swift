//
//  DummyData.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

let dummyMixedSound = MixedSound(name: "dummy0",
                                 baseSound: baseSounds[1],
                                 melodySound: melodySounds[1],
                                 whiteNoiseSound: whiteNoiseSounds[1],
                                 fileName: "Recipe1")

let dummyMixedSound1 = MixedSound(name: "dummy1",
                                  baseSound: baseSounds[2],
                                  melodySound: melodySounds[2],
                                  whiteNoiseSound: whiteNoiseSounds[2],
                                  fileName: "Recipe1")

let dummyMixedSound2 = MixedSound(name: "dummy2",
                                  baseSound: baseSounds[3],
                                  melodySound: melodySounds[3],
                                  whiteNoiseSound: whiteNoiseSounds[3],
                                  fileName: "Recipe1")

let dummyMixedSound3 = MixedSound(name: "dummy3",
                                  baseSound: baseSounds[4],
                                  melodySound: melodySounds[4],
                                  whiteNoiseSound: whiteNoiseSounds[4],
                                  fileName: "Recipe1")

let dummyBaseSound = Sound(id: 0,
                           name: BaseAudioName.longSun.fileName,
                           soundType: .base,
                           audioVolume: 0.8,
                           fileName: "gong1")

let dummyMelodySound = Sound(id: 2,
                             name: MelodyAudioName.ambient.fileName,
                             soundType: .melody,
                             audioVolume: 1.0,
                             fileName: "Melody1")

let dummyWhiteNoiseSound = Sound(id: 6,
                              name: WhiteNoiseAudioName.dryGrass.fileName,
                              soundType: .whiteNoise,
                              audioVolume: 0.4,
                              fileName: "field")
