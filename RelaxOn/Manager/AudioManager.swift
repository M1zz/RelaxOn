//
//  AudioManager.swift
//  RelaxOn
//
//  Created by hyunho lee on 5/25/22.
//

import Foundation
import AVKit

final class AudioManager {
    var player: AVAudioPlayer?
    
    private enum MusicExtension: String {
        case mp3 = "mp3"
    }
    
    private func getPathUrl(forResource: String, musicExtension: MusicExtension) -> URL? {
        Bundle.main.url(forResource: forResource, withExtension: musicExtension.rawValue) ?? nil
    }
    
    func startPlayer(track: String, volume: Float? = 1.0) {
        guard let url = getPathUrl(forResource: track, musicExtension: .mp3),
              let volume = volume else {
            self.player = nil
            print("resource not found \(track)")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("fail to initialize player")
        }
    }
    
    func playPause() {
        guard let player = player else {
            print("Instance of player not found")
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
            print("Instance of player not found")
            return
        }
        if player.isPlaying {
            player.stop()
        }
    }
    
    func changeVolume(track: String, volume: Float) {
        
        guard let url = getPathUrl(forResource: track, musicExtension: .mp3) else {
            print("resource not found \(track)")
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
                print("fail to initialize player")
            }
        }
        
    }
    
}
