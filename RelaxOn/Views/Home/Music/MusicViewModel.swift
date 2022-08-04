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
    
    @Published var mixedSound: MixedSound? {
        didSet {
            play()
        }
    }
    
    func updateVolume(audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float)) {
        self.mixedSound?.baseSound?.audioVolume = audioVolumes.baseVolume
        self.mixedSound?.melodySound?.audioVolume = audioVolumes.melodyVolume
        self.mixedSound?.naturalSound?.audioVolume = audioVolumes.naturalVolume
    }
    
    func changeMixedSound(mixedSound: MixedSound) {
        self.mixedSound = mixedSound
    }
    
    func fetchData(data: MixedSound) {
        mixedSound = data
        guard let mixedSound = mixedSound else { return }
        self.setupremoteCommandCenter()
        self.setupremoteCommandInfoCenter(mixedSound: mixedSound)
    }
    
    func play() {
        if isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            naturalAudioManager.playPause()
            //            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
        } else {
            // play 할 때 mixedSound 볼륨 적용 시도
            baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "base_default", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "base_default", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
            naturalAudioManager.startPlayer(track: mixedSound?.naturalSound?.name ?? "base_default", volume: mixedSound?.naturalSound?.audioVolume ?? 0.8)
            //            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1
        }
    }
    
    func stop() {
        if isPlaying {
            baseAudioManager.stop()
            melodyAudioManager.stop()
            naturalAudioManager.stop()
        }
    }
    
    func setupremoteCommandCenter() {
        // remote control event 받기 시작
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.removeTarget(nil) // -> 왜 있는 걸까
        center.pauseCommand.removeTarget(nil) // -> 왜 있는 걸까
        center.playCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
            self.isPlaying = true
            self.play()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: self.baseAudioManager.player?.currentTime ?? 0.0)
            // 재생 할 땐 now playing item의 rate를 1로 설정하여 시간이 흐르도록 합니다.
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1
            return .success
        }
        
        center.pauseCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
            self.isPlaying = true
            self.play()
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: self.baseAudioManager.player?.currentTime ?? 0.0)
            // 일시정지 할 땐 now playing item의 rate를 0으로 설정하여 시간이 흐르지 않도록 합니다.
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0
            return .success
        }
        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
    }
    
    func setupremoteCommandInfoCenter(mixedSound: MixedSound) {
        let center = MPNowPlayingInfoCenter.default()
        let remoteCenter = MPRemoteCommandCenter.shared()
        var nowPlayingInfo = center.nowPlayingInfo ?? [String: Any]()
        remoteCenter.nextTrackCommand.removeTarget(nil)
        remoteCenter.previousTrackCommand.removeTarget(nil)
        remoteCenter.nextTrackCommand.addTarget { MPRemoteCommandEvent in
            self.setupNextTrack(mixedSound: mixedSound)
            return .success
        }
        
        remoteCenter.previousTrackCommand.addTarget { MPRemoteCommandEvent in
            self.setupPreveiousTrack(mixedSound: mixedSound)
            return .success
        }
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = mixedSound.name
        if let albumCoverPage = UIImage(named: mixedSound.imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumCoverPage.size, requestHandler: { size in
                return albumCoverPage
            })
        }
        // 콘텐츠 총 길이
//        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.baseAudioManager.player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: self.baseAudioManager.player?.currentTime ?? 0.0)
        
        center.nowPlayingInfo = nowPlayingInfo
    }
    
    func setupNextTrack(mixedSound: MixedSound) {
        let count = mixedSoundList.count
        let id = mixedSound.id
        if id == count - 1 {
            guard let firstSong = mixedSoundList.first else { return }
            self.mixedSound = firstSong
            self.setupremoteCommandInfoCenter(mixedSound: firstSong)
        } else {
            let nextSong = mixedSoundList[ mixedSoundList.firstIndex { $0.id == id + 1} ?? 0 ]
            self.mixedSound = nextSong
            self.setupremoteCommandInfoCenter(mixedSound: nextSong)
        }
    }
    
    func setupPreveiousTrack(mixedSound: MixedSound) {
        let id = mixedSound.id
        if id == 0 {
            guard let lastSong = mixedSoundList.last else { return }
            self.mixedSound = lastSong
            self.setupremoteCommandInfoCenter(mixedSound: lastSong)
        } else {
            let previousSong = mixedSoundList[ mixedSoundList.firstIndex { $0.id == id - 1} ?? 0 ]
            self.mixedSound = previousSong
            self.setupremoteCommandInfoCenter(mixedSound: previousSong)
        }
    }
}
