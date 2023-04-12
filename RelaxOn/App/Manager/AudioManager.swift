//
//  AudioManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/24.
//

import AVFoundation
import SwiftUI
import Combine

final class AudioManager: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer?
    @Published var volume: Float = 0.5
    
    private enum MusicExtension: String {
        case mp3
    }
    
    private func getPathUrl(forResource: String, musicExtension: MusicExtension) -> URL? {
        Bundle.main.url(forResource: forResource, withExtension: musicExtension.rawValue) ?? nil
    }
    
    var currentVolume: Binding<Float> {
        Binding<Float>(
            get: {
                self.audioPlayer?.volume ?? self.volume
            },
            set: { newValue in
                self.volume = newValue
                self.audioPlayer?.volume = newValue
            }
        )
    }
    
    /// Sound타입의 객체를 반복 재생
    func playAudio(sound: Sound) {
        if let url = getPathUrl(forResource: sound.name, musicExtension: .mp3) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url) // url 기반으로 음원 재생이 가능한 플레이어 객체를 생성, 오류가 발생하면 catch 블록으로 이동한다.
                audioPlayer?.prepareToPlay() // 오디오 파일을 메모리에 로드
                audioPlayer?.volume = sound.volume // 플레이어의 볼륨을 전달 받은 mixedSound의 볼륨값으로 설정
                audioPlayer?.numberOfLoops = -1 // 오디오 파일이 무한 루프로 반복되는 횟수를 설정 (-1: 무한반복, 0: 반복안함, 1: 1번만 반복)
                audioPlayer?.play()
            } catch {
                print("Audio playback error: \(error.localizedDescription)")
            }
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0 // currentTime을 0으로 설정하지 않으면 오디오 플레이어가 중지된 지점부터 play()됨
    }
    
    func playMixedSound(_ mixedSound: MixedSound) {
        guard let fileURL = URL(string: mixedSound.audioFileURL) else {
            print("파일의 URL을 가져올 수 없습니다.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = mixedSound.volume
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Audio playback error: \(error.localizedDescription)")
        }
    }

}
