//
//  MixedSoundsViewModel.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/04/12.
//

import Foundation

/**
 View와 직접적으로 사운드 데이터 바인딩하는 ViewModel 객체
 */
final class MixedSoundsViewModel: ObservableObject {
    
    /// UserDefaults에 저장된 음원 목록
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
    
    func saveMixedSound(_ mixedSound: MixedSound, completion: @escaping (Result<Void, MixedSoundError>) -> Void) {
        do {
            try UserFileManager.shared.saveMixedSound(mixedSound)
            completion(.success(()))
        } catch {
            if let mixedSoundError = error as? MixedSoundError {
                completion(.failure(mixedSoundError))
            } else {
                completion(.failure(.fileSaveFailed))
            }
        }
    }
}
