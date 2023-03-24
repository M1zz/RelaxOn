//
//  AudioManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/24.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    
    private enum MusicExtension: String {
        case mp3 = "mp3"
    }
    
    private func getPathUrl(forResource: String, musicExtension: MusicExtension) -> URL? {
        Bundle.main.url(forResource: forResource, withExtension: musicExtension.rawValue) ?? nil
    }
    
    /// MixedSound타입의 객체를 재생
    func playAudio(mixedSound: MixedSound) {
        if let url = getPathUrl(forResource: mixedSound.fileName, musicExtension: .mp3) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay() //
                audioPlayer?.volume = mixedSound.volume
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch {
                print(#function)
                print("Audio playback error: \(error.localizedDescription)")
            }
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
}
