//
//  AudioEngineManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import AVFoundation
import Combine

final class AudioEngineManager: ObservableObject {
    static let shared = AudioEngineManager()
    
    var engine = AVAudioEngine()
    
    private var player = AVAudioPlayerNode()
    private var pitchEffect = AVAudioUnitTimePitch()
    private var volumeEffect = AVAudioMixerNode()
    private var audioFile: AVAudioFile?
    private var audioBuffer: AVAudioPCMBuffer?
    private var scheduleCompletionHandler: (() -> Void)?
    private var intervalCancellable: AnyCancellable?
    private var timerSubscription: Cancellable?
    
    @Published private var currentPlayingSound: Playable?
    @Published var interval: Double = 1.0
    
    @Published var pitch: Double = 0 {
        didSet {
            pitchEffect.pitch = Float(pitch * 100)
        }
    }
    
    @Published var volume: Float = 1.0 {
        didSet {
            volumeEffect.outputVolume = volume
        }
    }
    
    @Published var audioVariation: AudioVariation = AudioVariation() {
        didSet {
            self.pitchEffect.pitch = Float(audioVariation.pitch * 100)
            self.volumeEffect.outputVolume = audioVariation.volume
            self.interval = Double(audioVariation.interval)
        }
    }
    
    private init() {
        setupAudioSession()
        setupEngine()
        setupSubscriptions()
    }
}

// MARK: - Setup
extension AudioEngineManager {
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup error: \(error.localizedDescription)")
        }
    }
    
    private func setupEngine() {
        engine.attach(player)
        engine.attach(pitchEffect)
        engine.attach(volumeEffect)
    }
    
    private func setupConnections() {
        if engine.isRunning {
            engine.stop()
        }
        if let audioFile = audioFile {
            engine.connect(player, to: pitchEffect, format: audioFile.processingFormat)
            engine.connect(pitchEffect, to: volumeEffect, format: audioFile.processingFormat)
            engine.connect(volumeEffect, to: engine.mainMixerNode, format: audioFile.processingFormat)
        }
        do {
            try engine.start()
        } catch {
            print("Unable to start engine: \(error.localizedDescription)")
        }
    }
    
    /**
     오디오 재생 간격이 변경되었을 때 이를 감지하여 새 버퍼를 스케줄링하는 구독을 설정합니다.
     Combine을 이용하여 'interval' 프로퍼티의 값이 변동되면 300 밀리초 후에 scheduleNextBuffer 함수를 호출합니다.
     */
    private func setupSubscriptions() {
        intervalCancellable = $interval
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.timerSubscription?.cancel()
                self?.scheduleNextBuffer()
            }
    }
    
}

// MARK: - Play & Pause
extension AudioEngineManager {

    func play<T: Playable>(with sound: T) {
        print(#function)
        
        currentPlayingSound = sound
        
        let targetFile = sound.filter.rawValue
        guard let fileURL = Bundle.main.url(forResource: targetFile, withExtension: MusicExtension.mp3.rawValue) else {
            print("File not found")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: fileURL)
            audioBuffer = prepareBuffer()
            setupConnections()
            
            if let customSound = sound as? CustomSound {
                audioVariation = customSound.audioVariation
            }
            
            scheduleNextBuffer(with: sound)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stop() {
        timerSubscription?.cancel()
        player.stop()
        engine.stop()
        clearBuffer()
    }
}

// MARK: - Buffer
extension AudioEngineManager {
    
    private func clearBuffer() {
        audioBuffer = nil
    }
    
    private func prepareBuffer() -> AVAudioPCMBuffer? {
        print(#function)
        
        guard let audioFile = audioFile else { return nil }
        
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat,
                                      frameCapacity: AVAudioFrameCount(audioFile.length))!
        do {
            try audioFile.read(into: buffer)
        } catch {
            print("Failed to read buffer")
            return nil
        }
        return buffer
    }
    
    /**
     다음 오디오 버퍼를 스케줄링합니다. 준비된 버퍼를 사용해 오디오를 재생하고, 주어진 인터벌에 따라 다음 버퍼 재생을 스케줄링합니다.
     Combine 프레임워크의 Timer.publish를 사용하여 지정된 인터벌마다 버퍼 재생을 반복합니다.
     */
    private func scheduleNextBuffer(with playingSound: Playable? = nil) {
        print(#function)
        
        guard let buffer = audioBuffer else {
            print("Failed to prepare buffer")
            return
        }
        
        guard let sound = playingSound ?? currentPlayingSound else {
            print("No playing sound")
            return
        }
        
        // 취소 가능한 타이머를 만듭니다.
        timerSubscription?.cancel()
        
        timerSubscription = Timer.publish(
            every: interval + sound.filter.duration,
            on: RunLoop.main,
            in: .common
        )
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.player.pause()
                
                let scheduleTime = AVAudioTime(hostTime: mach_absolute_time())
                self.player.scheduleBuffer(buffer, at: scheduleTime) { [weak self] in
                    self?.scheduleCompletionHandler?()
                    self?.scheduleCompletionHandler = nil
                }

                if !self.engine.isRunning {
                    do {
                        try self.engine.start()
                    } catch {
                        print("Unable to start engine: \(error.localizedDescription)")
                    }
                }
                
                if !self.player.isPlaying {
                    self.player.play()
                }
            }
    }
}
