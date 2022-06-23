//
//  AudioManager.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import Foundation
import AVKit
import MediaPlayer

final class AudioManager {
    static let shared = AudioManager()
    var player: AVAudioPlayer?
    
    func startPlayer(track: String, volume: Float? = 1.0) {
        guard let url = Bundle.main.url(forResource: track,
                                        withExtension: "mp3") else {
            print("resource not found \(track)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume!
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
    
    func chanegeVolume(track: String, volume: Float) {
        
        guard let url = Bundle.main.url(forResource: track,
                                        withExtension: "mp3") else {
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
