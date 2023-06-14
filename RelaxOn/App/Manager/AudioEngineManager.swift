//
//  AudioEngineManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import AVFoundation

/**
 AVAudioEngine 객체를 이용한 음원 커스텀 & 재생 & 정지 기능
 */
final class AudioEngineManager: ObservableObject {
    static let shared = AudioEngineManager()
  
    var engine = AVAudioEngine()
  
    private var player = AVAudioPlayerNode()
    private var pitchEffect = AVAudioUnitTimePitch()
    private var volumeEffect = AVAudioMixerNode()
    private var audioFile: AVAudioFile?
    private var audioBuffer: AVAudioPCMBuffer?

    @Published var interval: Double = 1.0 {
        didSet {
            scheduleNextBuffer(interval: interval)
        }
    }
    
    @Published var pitch: Double = 0 {
        didSet {
            pitchEffect.pitch = Float(pitch * 100)
        }
    }
    
    @Published var volume: Float = 1.0 {
        didSet {
            player.volume = volume
        }
    }
    
    @Published var audioVariation: AudioVariation = AudioVariation() {
        didSet {
            self.pitchEffect.pitch = Float(audioVariation.pitch * 100)
            self.player.volume = audioVariation.volume
            self.interval = Double(audioVariation.interval)
        }
    }

    private init() { }

}

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
            engine.attach(player)
            engine.attach(pitchEffect)
            engine.attach(volumeEffect)
            
            if let audioFile = audioFile {
                engine.connect(player, to: pitchEffect, format: audioFile.processingFormat)
                engine.connect(pitchEffect, to: volumeEffect, format: audioFile.processingFormat)
                engine.connect(volumeEffect, to: engine.mainMixerNode, format: audioFile.processingFormat)
            }
            
            try engine.start()
            
            if audioBuffer == nil {
                audioBuffer = prepareBuffer()
            }
            
            if let customSound = sound as? CustomSound {
                audioVariation = customSound.audioVariation
                scheduleNextBuffer(interval: Double(customSound.audioVariation.interval))
            } else {
                scheduleNextBuffer()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func stop() {
        clearBuffer()
        if engine.isRunning {
            player.stop()
            engine.stop()
            player.reset()
        }
    }
    
    /**
     오디오 파일을 AVAudioPCMBuffer로 준비합니다.
     AVAudioFile을 읽어서 AVAudioPCMBuffer로 변환합니다. 이 함수는 재생 준비 과정에서 사용됩니다.
     */
    private func prepareBuffer() -> AVAudioPCMBuffer? {
        print(#function)
        
        guard let audioFile = audioFile else { return nil }
        let audioFileLength = AVAudioFrameCount(audioFile.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: audioFileLength) else { return nil }
        
        do {
            try audioFile.read(into: buffer)
            print("오디오 파일을 buffer에 읽어옵니다.")
            
        } catch {
            print("오디오 파일을 buffer에 읽어오지 못했습니다.: \(error)")
            return nil
        }
        return buffer
    }
    
    func prepareBuffer(audioFile: AVAudioFile?) -> AVAudioPCMBuffer? {
        print(#function)
        
        guard let audioFile = audioFile else { return nil }
        let audioFileLength = AVAudioFrameCount(audioFile.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: audioFileLength) else { return nil }
        
        do {
            try audioFile.read(into: buffer)
            print("오디오 파일을 buffer에 읽어옵니다.")
            
        } catch {
            print("오디오 파일을 buffer에 읽어오지 못했습니다.: \(error)")
            return nil
        }
        return buffer
    }

    /**
     다음 버퍼를 스케줄하는 함수입니다.
     이 함수는 현재 재생 중인 음원 파일에서 다음 버퍼를 스케줄합니다.
     완료 핸들러를 설정하여 다음 버퍼를 스케줄하기 전에 일정 시간 동안 대기하도록 합니다.
     */
    private func scheduleNextBuffer() {
        print(#function)
        guard let buffer = audioBuffer else {
            print("Failed to prepare buffer")
            return
        }
        
        if player.isPlaying {
            player.scheduleBuffer(buffer, completionHandler: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + (self?.interval ?? 1.0)) {
                    if self?.player.isPlaying == true {
                        self?.scheduleNextBuffer()
                    }
                }
            })
            if engine.isRunning {
                player.play()
            } else {
                do {
                    try engine.start()
                    player.play()
                } catch {
                    print("Unable to start engine: \(error.localizedDescription)")
                }
            }
            player.rate = Float(interval)
        }
    }

    private func scheduleNextBuffer(interval: Double = 1.0) {
        print(#function)
        guard let buffer = audioBuffer else {
            print("Failed to prepare buffer")
            return
        }
        player.scheduleBuffer(buffer, completionHandler: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + (interval)) {
                self?.scheduleNextBuffer()
            }
        })
        if engine.isRunning {
            player.play()
        } else {
            do {
                try engine.start()
                player.play()
            } catch {
                print("Unable to start engine: \(error.localizedDescription)")
            }
        }
        player.rate = Float(interval)
    }

    func clearBuffer() {
        guard let bufferFormat = audioBuffer?.format else { return }
        let newBuffer = AVAudioPCMBuffer(pcmFormat: bufferFormat, frameCapacity: 1024)
        self.audioBuffer = newBuffer
    }
    
}
