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
    @Published var isPlaying: Bool = false {
        // FIXME: addMainSoundToWidget()를 Sound가 재정렬 되었을 때 제일 위의 음악을 넣어야 합니다. (해당 로직이 안 짜진 거 같아 우선은, 여기로 뒀습니다.)
        didSet {
            if let mixedSound = mixedSound {
                WidgetManager.addMainSoundToWidget(imageName: mixedSound.imageName, name: mixedSound.name, id: mixedSound.id)
            }
        }
    }
    
    @Published var mixedSound: MixedSound? {
        didSet {
            startPlayer()
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
        self.setupRemoteCommandCenter()
        self.setupRemoteCommandInfoCenter(mixedSound: mixedSound)
    }
    
    func playPause() {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            naturalAudioManager.playPause()
    }
    
    func stop() {
        baseAudioManager.stop()
        melodyAudioManager.stop()
        naturalAudioManager.stop()
    }
    
    func startPlayer() {
        baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "base_default", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
        melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "base_default", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
        naturalAudioManager.startPlayer(track: mixedSound?.naturalSound?.name ?? "base_default", volume: mixedSound?.naturalSound?.audioVolume ?? 0.8)
    }
    
    func setupRemoteCommandCenter() {
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.removeTarget(nil)
        center.pauseCommand.removeTarget(nil)
        center.nextTrackCommand.removeTarget(nil)
        center.previousTrackCommand.removeTarget(nil)
        guard let mixedSound = self.mixedSound else { return }
        
        center.playCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
            self.isPlaying = true
            self.playPause()
            return .success
        }
        
        center.pauseCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
            self.isPlaying = false
            self.playPause()
            return .success
        }
        
        center.nextTrackCommand.addTarget { MPRemoteCommandEvent in
            self.setupNextTrack(mixedSound: mixedSound)
            return .success
        }
        
        center.previousTrackCommand.addTarget { MPRemoteCommandEvent in
            self.setupPreviousTrack(mixedSound: mixedSound)
            return .success
        }
    }
    
    func setupRemoteCommandInfoCenter(mixedSound: MixedSound) {
        let center = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = center.nowPlayingInfo ?? [String: Any]()
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = mixedSound.name
        if let albumCoverPage = UIImage(named: mixedSound.imageName) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: albumCoverPage.size, requestHandler: { size in
                return albumCoverPage
            })
        }
        // MARK: - 타이머 연동돌 때 건드릴 코드
//        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = self.baseAudioManager.player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = 1
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: self.baseAudioManager.player?.currentTime ?? 0.0)
        
        center.nowPlayingInfo = nowPlayingInfo
    }
    
    func setupNextTrack(mixedSound: MixedSound) {
        let count = userRepositories.count
        let id = mixedSound.id
        if id == count - 1 {
            guard let firstSong = userRepositories.first else { return }
            self.mixedSound = firstSong
            self.setupRemoteCommandInfoCenter(mixedSound: firstSong)
            self.setupRemoteCommandCenter()
        } else {
            let nextSong = userRepositories[ userRepositories.firstIndex {
                $0.id == id + 1
            } ?? 0 ]
            self.mixedSound = nextSong
            self.setupRemoteCommandInfoCenter(mixedSound: nextSong)
            self.setupRemoteCommandCenter()
        }
    }
    
    func setupPreviousTrack(mixedSound: MixedSound) {
        let id = mixedSound.id
        if id == 0 {
            guard let lastSong = userRepositories.last else { return }
            self.mixedSound = lastSong
            self.setupRemoteCommandInfoCenter(mixedSound: lastSong)
            self.setupRemoteCommandCenter()
        } else {
            let previousSong = userRepositories[ userRepositories.firstIndex {
                $0.id == id - 1
            } ?? 0 ]
            self.mixedSound = previousSong
            self.setupRemoteCommandInfoCenter(mixedSound: previousSong)
            self.setupRemoteCommandCenter()
        }
    }
}
