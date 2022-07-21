//
//  AudioManager.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import Foundation
import AVKit
import OSLog

final class AudioManager {
    static let shared = AudioManager()
    var player: AVAudioPlayer?
    
    private enum MusicExtension: String {
        case mp3 = "mp3"
    }
    
    private func getPathUrl(forResource: String, musicExtension: MusicExtension) -> URL? {
       Bundle.main.url(forResource: forResource, withExtension: musicExtension.rawValue) ?? nil
    }
    
    func startPlayer(track: String, volume: Float? = 1.0) {
        guard let url = getPathUrl(forResource: track, musicExtension: .mp3) else {
            os_log(.error, log: .default, "startPlayer(), resource not found, track: \(track)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume!
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            os_log(.error, log: .default, "startPlayer(), fail to initialize player")
        }
    }
    
    func playPause() {
        guard let player = player else {
            os_log(.error, log: .default, "playPause(), Instance of player not found")
            return
        }
        if player.isPlaying {
            player.pause()
        } else {
            player.play()
        }
    }
    
    func stop() {
        guard let player = player else {
            os_log(.error, log: .default, "stop(), Instance of player not found")
            return
        }
        if player.isPlaying {
            player.stop()
        }
    }
    
    // TODO : track 변경하기
    func chanegeVolume(track: String, volume: Float) {
        
        guard let url = getPathUrl(forResource: track, musicExtension: .mp3) else {
            os_log(.error, log: .default, "chanegeVolume(), resource not found \(track)")
            return
        }
        
        if ((player?.isPlaying) != nil) {
            player?.volume = volume
        } else {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.volume = volume
                player?.numberOfLoops = -1
                player?.play()
            } catch {
                os_log(.error, log: .default, "chanegeVolume(), fail to initialize player")
            }
        }
        
    }
    
}
