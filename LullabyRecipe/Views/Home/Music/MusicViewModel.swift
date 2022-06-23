//
//  MusicViewModel.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI
import AVFoundation
import MediaPlayer

final class MusicViewModel: NSObject, ObservableObject {
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var naturalAudioManager = AudioManager()
    @Published var isPlaying: Bool = false
    
    @Published var mixedSound: MixedSound?
    
    @Published var player: AVAudioPlayer?
    func fetchData(data: MixedSound) {
        mixedSound = data
        
        guard let baseUrl = Bundle.main.url(forResource: mixedSound?.baseSound?.name, withExtension: "mp3"),
              let melodyUrl = Bundle.main.url(forResource: mixedSound?.melodySound?.name, withExtension: "mp3"),
              let naturalUrl = Bundle.main.url(forResource: mixedSound?.naturalSound?.name, withExtension: "mp3")
        else { return }
        
        do {
            baseAudioManager.player = try AVAudioPlayer(contentsOf: baseUrl)
            melodyAudioManager.player = try AVAudioPlayer(contentsOf: melodyUrl)
            naturalAudioManager.player = try AVAudioPlayer(contentsOf: naturalUrl)
        } catch {
            print("fail to initialize player")
        }
        
        self.setupRemoteTransportControls()
        self.setupNowPlaying(music: mixedSound ?? data)
    }
    
    func play() {
        if isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            naturalAudioManager.playPause()
        } else {
            baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "chinese_gong", volume: 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "chinese_gong")
            naturalAudioManager.startPlayer(track: mixedSound?.naturalSound?.name ?? "chinese_gong", volume: 0.5)
        }
    }
    
    func stop() {
        if isPlaying {
            baseAudioManager.stop()
            melodyAudioManager.stop()
            naturalAudioManager.stop()
        }
    }
    
    func setupRemoteTransportControls() {
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()

//        guard let basePlayer = baseAudioManager.player else { return }
        
        commandCenter.playCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
            if !(self.baseAudioManager.player?.isPlaying ?? false) {
                self.baseAudioManager.player?.play()
                self.melodyAudioManager.player?.play()
                self.naturalAudioManager.player?.play()
                return MPRemoteCommandHandlerStatus.success
            }
            return MPRemoteCommandHandlerStatus.commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
            if self.baseAudioManager.player?.isPlaying ?? false {
                self.baseAudioManager.player?.pause()
                self.melodyAudioManager.player?.pause()
                self.naturalAudioManager.player?.pause()
                return MPRemoteCommandHandlerStatus.success
            }
            return MPRemoteCommandHandlerStatus.commandFailed
        }
        print("successfully1")
    }
    
    func setupNowPlaying(music: MixedSound) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = music.name

        if let image = UIImage(named: music.imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.baseAudioManager.player?.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.baseAudioManager.player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.baseAudioManager.player?.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
        print("successfully2")
    }
}
