//
//  DummyData.swift
//  LullabyRecipe
//
//  Created by 최동권 on 2022/06/25.
//

import Foundation

let dummyMixedSound = MixedSound(id: 0,
                                 name: "dummy0",
                                 baseSound: baseSounds[1],
                                 melodySound: melodySounds[1],
                                 whiteNoiseSound: WhiteNoiseSounds[1],
                                 imageName: "Recipe1")

let dummyMixedSound1 = MixedSound(id: 1,
                                  name: "dummy1",
                                  baseSound: baseSounds[2],
                                  melodySound: melodySounds[2],
                                  naturalSound: naturalSounds[2],
                                  imageName: "Recipe1")

let dummyMixedSound2 = MixedSound(id: 2,
                                  name: "dummy2",
                                  baseSound: baseSounds[3],
                                  melodySound: melodySounds[3],
                                  naturalSound: naturalSounds[3],
                                  imageName: "Recipe1")

let dummyMixedSound3 = MixedSound(id: 3,
                                  name: "dummy3",
                                  baseSound: baseSounds[4],
                                  melodySound: melodySounds[4],
                                  naturalSound: naturalSounds[4],
                                  imageName: "Recipe1")

let dummyBaseSound = Sound(id: 0,
                           name: BaseAudioName.longSun.fileName,
                           soundType: .base,
                           audioVolume: 0.8,
                           imageName: "gong1")

let dummyMelodySound = Sound(id: 2,
                             name: MelodyAudioName.ambient.fileName,
                             soundType: .melody,
                             audioVolume: 1.0,
                             imageName: "Melody1")

let dummyWhiteNoiseSound = Sound(id: 6,
                              name: WhiteNoiseAudioName.dryGrass.fileName,
                              soundType: .whiteNoise,
                              audioVolume: 0.4,
                              imageName: "field")
