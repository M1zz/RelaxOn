//
//  MixedSoundsViewModel.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/04/12.
//

import Foundation

final class MixedSoundsViewModel: ObservableObject {
    
    @Published var mixedSounds: [MixedSound] = [] {
        didSet {
            UserDefaultsManager.shared.mixedSounds = mixedSounds
        }
    }
    
    func loadMixedSound() {
        mixedSounds = UserDefaultsManager.shared.mixedSounds
    }
    
    func removeMixedSound(at index: Int) {
        let mixedSound = mixedSounds[index]
        do {
            try UserFileManager.shared.deleteMixedSound(mixedSound)
            UserDefaultsManager.shared.removeMixedSound(mixedSound)
            mixedSounds.remove(at: index)
        } catch {
            print("MixedSound 파일을 삭제하지 못했습니다: \(error.localizedDescription)")
        }
    }
}
