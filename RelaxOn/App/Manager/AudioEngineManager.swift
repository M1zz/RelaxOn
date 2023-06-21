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
    
    @Published var interval: Double = 1.0 {
        didSet {
            scheduleNextBuffer()
        }
    }
    
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
        if let audioFile = audioFile {
            engine.connect(player, to: pitchEffect, format: audioFile.processingFormat)
            engine.connect(pitchEffect, to: volumeEffect, format: audioFile.processingFormat)
            engine.connect(volumeEffect, to: engine.mainMixerNode, format: audioFile.processingFormat)
        }
    }
    
    private func setupSubscriptions() {
        intervalCancellable = $interval
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.scheduleNextBuffer()
            }
    }
    
}

// MARK: - Play & Pause
extension AudioEngineManager {

    func play<T: Playable>(with sound: T) {
        print(#function)
        
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
            
            scheduleNextBuffer()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func stop() {
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
    
    private func scheduleNextBuffer() {
        print(#function)
        
        guard let buffer = audioBuffer else {
            print("Failed to prepare buffer")
            return
        }
        
        // 취소 가능한 타이머를 만듭니다.
        timerSubscription?.cancel()
        timerSubscription = Timer.publish(every: interval, on: RunLoop.main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.player.pause()
                
                let scheduleTime = AVAudioTime(hostTime: mach_absolute_time())
                self.player.scheduleBuffer(buffer, at: scheduleTime) { [weak self] in
                    self?.scheduleCompletionHandler?()
                    self?.scheduleCompletionHandler = nil
                    
                    DispatchQueue.main.async {
                        if self?.audioBuffer != nil {
                            self?.scheduleNextBuffer()
                        }
                    }
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
