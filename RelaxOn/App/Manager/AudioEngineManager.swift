//
//  AudioEngineManager.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import AVFoundation
import Combine
import SwiftUI

final class AudioEngineManager: ObservableObject {
    
    // MARK: - Properties
    static let shared = AudioEngineManager()
    
    var engine = AVAudioEngine()

    // 메인 사운드 (물방울 등)
    private var player = AVAudioPlayerNode()
    private var pitchEffect = AVAudioUnitTimePitch()
    private var volumeEffect = AVAudioMixerNode()
    private var audioFile: AVAudioFile?
    private var audioBuffer: AVAudioPCMBuffer?
    private var scheduleCompletionHandler: (() -> Void)?
    private var intervalCancellable: AnyCancellable?
    private var timerSubscription: Cancellable?
    private var fadeTimer: Timer?
    private var targetVolume: Float = 1.0

    // 배경음 (wave, rain, tv 등)
    private var backgroundPlayer = AVAudioPlayerNode()
    private var backgroundVolumeEffect = AVAudioMixerNode()
    private var backgroundAudioFile: AVAudioFile?
    private var backgroundBuffer: AVAudioPCMBuffer?
    @Published var backgroundVolume: Float = 0.3 {
        didSet {
            backgroundVolumeEffect.outputVolume = backgroundVolume
        }
    }
    @Published var currentBackgroundSound: BackgroundSound?

    @Published private var currentPlayingSound: Playable?
    @Published var interval: Double = 1.0

    // 실제 재생 이벤트를 알리기 위한 Publisher
    let soundDidPlay = PassthroughSubject<(volume: Float, pitch: Float), Never>()
    
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

    /// 랜덤 값을 적용한 실제 간격 계산
    private func getRandomizedInterval() -> Double {
        let baseInterval = Double(audioVariation.interval)
        let variation = Double(audioVariation.intervalVariation)

        if variation > 0 {
            // 변동폭만큼 랜덤하게 조정 (예: 30% 변동 = ±30%)
            let randomFactor = Double.random(in: -variation...variation)
            let randomizedInterval = baseInterval * (1.0 + randomFactor)
            return max(0.1, randomizedInterval) // 최소 0.1초
        }

        return baseInterval
    }

    /// 랜덤 값을 적용한 실제 볼륨 계산
    private func getRandomizedVolume() -> Float {
        let baseVolume = audioVariation.volume
        let variation = audioVariation.volumeVariation

        if variation > 0 {
            // 변동폭만큼 랜덤하게 조정
            let randomFactor = Float.random(in: -variation...variation)
            let randomizedVolume = baseVolume * (1.0 + randomFactor)
            return max(0.1, min(1.0, randomizedVolume)) // 0.1 ~ 1.0 범위
        }

        return baseVolume
    }

    /// 랜덤 값을 적용한 실제 피치 계산
    private func getRandomizedPitch() -> Float {
        let basePitch = audioVariation.pitch
        let variation = audioVariation.pitchVariation

        if variation > 0 {
            // 변동폭만큼 랜덤하게 조정 (피치는 -24 ~ +24 semitones 범위)
            let randomFactor = Float.random(in: -variation...variation)
            let randomizedPitch = basePitch + (randomFactor * 24.0) // 최대 ±24 semitones 변동
            return max(-24.0, min(24.0, randomizedPitch)) // -24 ~ +24 범위
        }

        return basePitch
    }
    
    // MARK: - Initialization
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
        print("🔗 [AudioEngineManager] setupConnections() 호출됨")
        print("   - Engine 실행 중: \(engine.isRunning)")
        print("   - 배경음 재생 중: \(currentBackgroundSound?.rawValue ?? "없음")")

        // ⚠️ 중요: 배경음이 재생 중이면 engine을 멈추지 않음!
        if engine.isRunning && currentBackgroundSound == nil {
            print("   - 배경음 없음: Engine 중지 후 재연결")
            engine.stop()
        } else if engine.isRunning && currentBackgroundSound != nil {
            print("   - 배경음 재생 중: Engine 유지하고 메인 노드만 재연결")
            // 기존 연결 해제
            engine.disconnectNodeInput(player)
            engine.disconnectNodeInput(pitchEffect)
            engine.disconnectNodeInput(volumeEffect)
        }

        if let audioFile = audioFile {
            engine.connect(player, to: pitchEffect, format: audioFile.processingFormat)
            engine.connect(pitchEffect, to: volumeEffect, format: audioFile.processingFormat)
            engine.connect(volumeEffect, to: engine.mainMixerNode, format: audioFile.processingFormat)
            print("   ✅ 메인 사운드 노드 연결 완료")
        }

        if !engine.isRunning {
            do {
                try engine.start()
                print("   ✅ Engine 시작 완료")
            } catch {
                print("   ❌ Engine 시작 실패: \(error.localizedDescription)")
            }
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
        print("🎵 [AudioEngineManager] play() 호출됨")
        print("   - 재생할 사운드: \(sound.filter.rawValue)")
        print("   - 현재 배경음 재생 중: \(currentBackgroundSound?.rawValue ?? "없음")")

        currentPlayingSound = sound

        let targetFile = sound.filter.rawValue
        guard let fileURL = Bundle.main.url(forResource: targetFile, withExtension: MusicExtension.mp3.rawValue) else {
            print("❌ [AudioEngineManager] 파일을 찾을 수 없음: \(targetFile)")
            return
        }

        do {
            audioFile = try AVAudioFile(forReading: fileURL)
            audioBuffer = prepareBuffer()
            setupConnections()

            if let customSound = sound as? CustomSound {
                audioVariation = customSound.audioVariation

                // 배경음이 저장되어 있으면 함께 재생
                if let backgroundSoundName = customSound.backgroundSound,
                   let backgroundSound = BackgroundSound(rawValue: backgroundSoundName) {
                    print("🎵 [AudioEngineManager] 저장된 배경음 재생: \(backgroundSoundName)")

                    // 저장된 배경 볼륨 적용
                    if let savedBackgroundVolume = customSound.backgroundVolume {
                        self.backgroundVolume = savedBackgroundVolume
                        print("   - 배경 볼륨: \(savedBackgroundVolume)")
                    }

                    playBackground(backgroundSound)
                }
            }

            scheduleNextBuffer(with: sound)
            print("✅ [AudioEngineManager] 메인 사운드 재생 시작 완료")

        } catch {
            print("❌ [AudioEngineManager] 재생 오류: \(error.localizedDescription)")
        }
    }

    func stop() {
        print("⏹️ [AudioEngineManager] stop() 호출됨")
        print("   - 배경음 상태: \(currentBackgroundSound?.rawValue ?? "없음")")

        fadeTimer?.invalidate()
        fadeTimer = nil
        timerSubscription?.cancel()
        player.stop()

        // 🔧 수정: 배경음은 유지하고 메인 사운드만 중지
        // backgroundPlayer.stop() // 제거됨

        // Engine은 배경음이 재생 중이면 중지하지 않음
        if currentBackgroundSound == nil {
            engine.stop()
            print("   - 배경음 없음: Engine 중지")
        } else {
            print("   - 배경음 재생 중: Engine 유지, 메인 사운드만 중지")
        }

        clearBuffer()
        print("✅ [AudioEngineManager] 메인 사운드만 중지 완료 (배경음 유지)")
    }

    func stopAll() {
        print("⏹️ [AudioEngineManager] stopAll() 호출됨 - 모든 사운드 중지")

        fadeTimer?.invalidate()
        fadeTimer = nil
        timerSubscription?.cancel()
        player.stop()
        backgroundPlayer.stop()
        engine.stop()
        clearBuffer()

        print("✅ [AudioEngineManager] 모든 사운드 중지 완료")
    }

    func stopWithFade(duration: TimeInterval = 5.0, completion: (() -> Void)? = nil) {
        fadeOut(duration: duration) { [weak self] in
            self?.stop()
            completion?()
        }
    }
}

// MARK: - Fade Effects
extension AudioEngineManager {

    /// 페이드 인: 볼륨을 0에서 목표 볼륨까지 서서히 증가
    func fadeIn(duration: TimeInterval = 3.0, targetVolume: Float? = nil) {
        fadeTimer?.invalidate()

        let target = targetVolume ?? audioVariation.volume
        self.targetVolume = target

        // 시작 볼륨을 0으로 설정
        volumeEffect.outputVolume = 0.0

        let steps = 30 // 30단계로 나눔
        let stepDuration = duration / Double(steps)
        let volumeIncrement = target / Float(steps)

        var currentStep = 0

        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            currentStep += 1

            if currentStep >= steps {
                self.volumeEffect.outputVolume = target
                timer.invalidate()
                self.fadeTimer = nil
            } else {
                self.volumeEffect.outputVolume = volumeIncrement * Float(currentStep)
            }
        }
    }

    /// 페이드 아웃: 현재 볼륨에서 0까지 서서히 감소
    func fadeOut(duration: TimeInterval = 5.0, completion: (() -> Void)? = nil) {
        fadeTimer?.invalidate()

        let startVolume = volumeEffect.outputVolume
        let steps = 50 // 50단계로 나눔
        let stepDuration = duration / Double(steps)
        let volumeDecrement = startVolume / Float(steps)

        var currentStep = 0

        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                completion?()
                return
            }

            currentStep += 1

            if currentStep >= steps {
                self.volumeEffect.outputVolume = 0.0
                timer.invalidate()
                self.fadeTimer = nil
                completion?()
            } else {
                self.volumeEffect.outputVolume = startVolume - (volumeDecrement * Float(currentStep))
            }
        }
    }

    /// 페이드 효과 취소
    func cancelFade() {
        fadeTimer?.invalidate()
        fadeTimer = nil
        // 원래 볼륨으로 복원
        volumeEffect.outputVolume = targetVolume
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

        // 랜덤화된 간격 계산
        let randomizedInterval = getRandomizedInterval()

        timerSubscription = Timer.publish(
            every: randomizedInterval + sound.filter.duration,
            on: RunLoop.main,
            in: .common
        )
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.player.pause()

                // 랜덤화된 볼륨 적용
                let randomizedVolume = self.getRandomizedVolume()
                self.volumeEffect.outputVolume = randomizedVolume

                // 랜덤화된 피치 적용
                let randomizedPitch = self.getRandomizedPitch()
                self.pitchEffect.pitch = randomizedPitch * 100 // AVAudioUnitTimePitch는 cents 단위 (100 cents = 1 semitone)

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

                // 재생 이벤트 발행 (물방울 애니메이션 싱크용)
                self.soundDidPlay.send((volume: randomizedVolume, pitch: randomizedPitch))

                // 다음 재생을 위한 새로운 타이머 (랜덤 간격으로 재스케줄)
                self.scheduleNextBuffer()
            }
    }
}

// MARK: - Background Sound

extension AudioEngineManager {

    /// 배경음 재생
    func playBackground(_ background: BackgroundSound) {
        currentBackgroundSound = background

        // subdirectory 없이 파일명으로만 검색 시도
        guard let fileURL = Bundle.main.url(forResource: background.fileName, withExtension: "mp3") else {
            print("Background file not found: \(background.fileName)")
            print("Available resources: \(Bundle.main.paths(forResourcesOfType: "mp3", inDirectory: nil))")
            return
        }

        print("✅ Background file found: \(fileURL.path)")

        do {
            backgroundAudioFile = try AVAudioFile(forReading: fileURL)
            backgroundBuffer = prepareBackgroundBuffer()

            if !engine.attachedNodes.contains(backgroundPlayer) {
                engine.attach(backgroundPlayer)
                engine.attach(backgroundVolumeEffect)

                if let audioFile = backgroundAudioFile {
                    engine.connect(backgroundPlayer, to: backgroundVolumeEffect, format: audioFile.processingFormat)
                    engine.connect(backgroundVolumeEffect, to: engine.mainMixerNode, format: audioFile.processingFormat)
                }
            }

            backgroundVolumeEffect.outputVolume = backgroundVolume

            scheduleBackgroundLoop()

            if !engine.isRunning {
                try engine.start()
            }

            if !backgroundPlayer.isPlaying {
                backgroundPlayer.play()
            }

        } catch {
            print("Background play error: \(error.localizedDescription)")
        }
    }

    /// 배경음 중지
    func stopBackground() {
        backgroundPlayer.stop()
        currentBackgroundSound = nil
    }

    /// 배경음 버퍼 준비
    private func prepareBackgroundBuffer() -> AVAudioPCMBuffer? {
        guard let audioFile = backgroundAudioFile else { return nil }

        let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat,
                                      frameCapacity: AVAudioFrameCount(audioFile.length))!
        do {
            try audioFile.read(into: buffer)
        } catch {
            print("Failed to read background buffer")
            return nil
        }
        return buffer
    }

    /// 배경음 루프 스케줄링 (10분 파일을 계속 반복)
    private func scheduleBackgroundLoop() {
        guard let buffer = backgroundBuffer else { return }

        backgroundPlayer.scheduleBuffer(buffer, at: nil, options: .loops) { }
    }
}

/// 배경음 타입
enum BackgroundSound: String, CaseIterable {
    case wave = "파도"
    case rain = "비"
    case tv = "TV 소음"

    var fileName: String {
        switch self {
        case .wave: return "wave_10min"
        case .rain: return "rain_10min"
        case .tv: return "tv_10min"
        }
    }

    var icon: String {
        switch self {
        case .wave: return "water.waves"
        case .rain: return "cloud.rain.fill"
        case .tv: return "tv.fill"
        }
    }

    var colors: [Color] {
        switch self {
        case .wave:
            return [
                Color(red: 0.2, green: 0.4, blue: 0.8).opacity(0.15),
                Color(red: 0.1, green: 0.5, blue: 0.9).opacity(0.1)
            ]
        case .rain:
            return [
                Color(red: 0.3, green: 0.4, blue: 0.6).opacity(0.15),
                Color(red: 0.2, green: 0.3, blue: 0.5).opacity(0.1)
            ]
        case .tv:
            return [
                Color(red: 0.5, green: 0.5, blue: 0.5).opacity(0.15),
                Color(red: 0.4, green: 0.4, blue: 0.4).opacity(0.1)
            ]
        }
    }
}
