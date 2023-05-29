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

    private var engine = AVAudioEngine()
    private var player = AVAudioPlayerNode()
    private var pitchEffect = AVAudioUnitTimePitch()
    private var audioFile: AVAudioFile?
    private var audioBuffer: AVAudioPCMBuffer?
    
    @Published var loopSpeed: Double = 1.0
    
    private init() { }
}

extension AudioEngineManager {
    
    func play(with originalSound: OriginalSound) {
        print(#function)
        
        guard let fileURL = getPathNSURL(forResource: originalSound.category.fileName, musicExtension: .mp3) else {
            print("File not found")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: fileURL as URL)
            
            engine.attach(player)
            engine.attach(pitchEffect)
            
            if let audioFile = audioFile {
                engine.connect(player, to: pitchEffect, format: audioFile.processingFormat)
                engine.connect(pitchEffect, to: engine.mainMixerNode, format: audioFile.processingFormat)
            }
            
            try engine.start()
            
            audioBuffer = prepareBuffer()
            scheduleNextBuffer()
            
        } catch {
            print("An error occurred: \(error.localizedDescription)")
        }
    }
    
    func play(with customSound: CustomSound) {
        print(#function)
        
        guard let fileURL = getPathNSURL(forResource: customSound.category.fileName, musicExtension: .wav) else {
            print("File not found")
            return
        }
        
        do {
            audioFile = try AVAudioFile(forReading: fileURL as URL)
            engine.attach(player)
            if let audioFile = audioFile {
                engine.connect(player, to: engine.mainMixerNode, format: audioFile.processingFormat)
            }
            try engine.start()
            audioBuffer = prepareBuffer()
            scheduleNextBuffer()
            
        } catch {
            print("An error occurred: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        if engine.isRunning {
            player.stop()
            engine.stop()
        }
    }
    
    func updateAudioVariation(volume: Float, pitch: Float, speed: Float) {
        // Update your engine configuration here
    }
    
    /**
     오디오 파일을 AVAudioPCMBuffer로 준비합니다.
     AVAudioFile을 읽어서 AVAudioPCMBuffer로 변환합니다. 이 함수는 재생 준비 과정에서 사용됩니다.
     */
    private func prepareBuffer() -> AVAudioPCMBuffer? {
        print(#function)
        
        guard let audioFile = audioFile else { return nil }
        
        // audioFile의 길이를 frame 수로 변환합니다.
        let audioFileLength = AVAudioFrameCount(audioFile.length)
        
        // audioFile의 format과 길이를 기반으로 PCM buffer를 생성합니다.
        guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: audioFileLength) else { return nil }
        
        do {
            // 오디오 파일을 buffer에 읽어옵니다.
            try audioFile.read(into: buffer)
            print("오디오 파일을 buffer에 읽어옵니다.")
            
        } catch {
            print("오디오 파일을 buffer에 읽어오지 못했습니다.")
            print("Error reading audio file into buffer: \(error)")
            return nil
        }
        // 준비된 buffer를 반환합니다.
        return buffer
    }
    
    /**
     다음 버퍼를 스케줄하는 함수입니다.
     이 함수는 현재 재생 중인 음원 파일에서 다음 버퍼를 스케줄합니다.
     완료 핸들러를 설정하여 다음 버퍼를 스케줄하기 전에 일정 시간 동안 대기하도록 합니다.
     */
    private func scheduleNextBuffer() {
        guard let buffer = audioBuffer else {
            print("Failed to prepare buffer")
            return
        }
        
        player.scheduleBuffer(buffer, completionHandler: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + (self?.loopSpeed ?? 1.0)) {
                self?.scheduleNextBuffer()
            }
        })
        
        if !player.isPlaying {
            player.play()
        }
    }
    
    /**
     현재 Buffer를 추출
     */
    func getAudioBuffer() -> AVAudioPCMBuffer? {
        return audioBuffer
    }
    
}
