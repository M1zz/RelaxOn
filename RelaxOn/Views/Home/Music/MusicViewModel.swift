//
//  MusicViewModel.swift
//  RelaxOn
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI
import AVFoundation
import MediaPlayer
import WatchConnectivity

final class MusicViewModel: NSObject, ObservableObject {
    @Published var watchInfo: String = ""
        
    override init() {
        super.init()

        guard WCSession.isSupported() else {
            return
        }

        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    public func send(cdInfos: [String]) {
        guard WCSession.default.activationState == .activated else {
            return
        }
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
        let userInfo: [String: [String]] = [
            "cdInfo" : cdInfos
        ]
        WCSession.default.transferUserInfo(userInfo)
    }
    
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var whiteNoiseAudioManager = AudioManager()
    @Published var isPlaying: Bool = true {
        // FIXME: addMainSoundToWidget()를 Sound가 재정렬 되었을 때 제일 위의 음악을 넣어야 합니다. (해당 로직이 안 짜진 거 같아 우선은, 여기로 뒀습니다.)
        didSet {
            if let mixedSound = mixedSound,
               let baseImageName = mixedSound.baseSound?.imageName,
               let melodyImageName = mixedSound.melodySound?.imageName,
               let whiteNoiseImageName = mixedSound.whiteNoiseSound?.imageName {
                WidgetManager.addMainSoundToWidget(baseImageName: baseImageName, melodyImageName: melodyImageName, whiteNoiseImageName: whiteNoiseImageName, name: mixedSound.name, id: mixedSound.id, isPlaying: isPlaying, isRecentPlay: false)
            }
        }
    }
    
    @Published var mixedSound: MixedSound? {
        didSet {
            startPlayer()
            updateCompanion()
        }
    }
    
    func updateVolume(audioVolumes: (baseVolume: Float, melodyVolume: Float, whiteNoiseVolume: Float)) {
        self.mixedSound?.baseSound?.audioVolume = audioVolumes.baseVolume
        self.mixedSound?.melodySound?.audioVolume = audioVolumes.melodyVolume
        self.mixedSound?.whiteNoiseSound?.audioVolume = audioVolumes.whiteNoiseVolume
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
        self.isPlaying.toggle()
        if !isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            whiteNoiseAudioManager.playPause()
        } else {
            // play 할 때 mixedSound 볼륨 적용 시도
            baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "base_default", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "base_default", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
            whiteNoiseAudioManager.startPlayer(track: mixedSound?.whiteNoiseSound?.name ?? "base_default", volume: mixedSound?.whiteNoiseSound?.audioVolume ?? 0.8)
        }
        updateCompanion()

    }
    
    func stop() {
        baseAudioManager.stop()
        melodyAudioManager.stop()
        whiteNoiseAudioManager.stop()
        updateCompanion()
    }
    
    func startPlayer() {
        baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "base_default", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
        melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "base_default", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
        whiteNoiseAudioManager.startPlayer(track: mixedSound?.whiteNoiseSound?.name ?? "base_default", volume: mixedSound?.whiteNoiseSound?.audioVolume ?? 0.8)
    }
    
    func setupRemoteCommandCenter() {
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.removeTarget(nil)
        center.pauseCommand.removeTarget(nil)
        center.nextTrackCommand.removeTarget(nil)
        center.previousTrackCommand.removeTarget(nil)
        guard let mixedSound = self.mixedSound else { return }
        
        center.playCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
            self.playPause()
            return .success
        }
        
        center.pauseCommand.addTarget { commandEvent -> MPRemoteCommandHandlerStatus in
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
        if let albumCoverPage = UIImage(named: mixedSound.baseSound?.name ?? "") {
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
        let index = userRepositories.firstIndex { element in
            element.name == mixedSound.name
        }
        self.isPlaying = true
        if index == count - 1 {
            guard let firstSong = userRepositories.first else { return }
            self.mixedSound = firstSong
            self.setupRemoteCommandInfoCenter(mixedSound: firstSong)
            self.setupRemoteCommandCenter()
            updateCompanion()
        } else {
            let nextSong = userRepositories[ userRepositories.firstIndex {
                $0.id > id
            } ?? 0 ]
            self.mixedSound = nextSong
            self.setupRemoteCommandInfoCenter(mixedSound: nextSong)
            self.setupRemoteCommandCenter()
            updateCompanion()
        }
    }
    
    func setupPreviousTrack(mixedSound: MixedSound) {
        let id = mixedSound.id
        let index = userRepositories.firstIndex { element in
            element.name == mixedSound.name
        }
        self.isPlaying = true
        if index == 0 {
            guard let lastSong = userRepositories.last else { return }
            self.mixedSound = lastSong
            self.setupRemoteCommandInfoCenter(mixedSound: lastSong)
            self.setupRemoteCommandCenter()
            updateCompanion()
        } else {
            let previousSong = userRepositories[ userRepositories.lastIndex {
                $0.id < id
            } ?? 0 ]
            self.mixedSound = previousSong
            self.setupRemoteCommandInfoCenter(mixedSound: previousSong)
            self.setupRemoteCommandCenter()
            updateCompanion()
        }
    }
    
    // Watch 업데이트
    func updateCompanion() {
        self.send(cdInfos: [isPlaying ? "true" : "false", mixedSound?.name ?? ""])
    }
}

extension MusicViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            let key = "watchInfo"
                guard let WatchInfo = userInfo[key] as? String else {
                return
            }
            
            switch WatchInfo {
            case "playing", "paused":
                self.playPause()
            case "prev":
                guard let mixedSound = self.mixedSound else {
                    return
                }
                self.setupPreviousTrack(mixedSound: mixedSound)
            case "next":
                guard let mixedSound = self.mixedSound else {
                    return
                }
                self.setupNextTrack(mixedSound: mixedSound)
            default:
                print("unknown watchinfo")
            }
        }
    }

    // iOS에만 해당
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    func sessionDidDeactivate(_ session: WCSession) {
        // 애플워치가 2개 이상일 때, 새로운 기기에서 다시 activate
        WCSession.default.activate()
    }
    #endif
}
