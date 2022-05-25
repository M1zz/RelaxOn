//
//  AudioManager.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import Foundation
import AVKit

final class AudioManager {
    static let shared = AudioManager()
    var player: AVAudioPlayer?
    
    func startPlayer(track: String) {
        guard let url = Bundle.main.url(forResource: track,
                                        withExtension: "mp3") else {
            print("resource not found \(track)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            player?.play()
        } catch {
            print("fail to initialize player")
        }
    }
    
}
