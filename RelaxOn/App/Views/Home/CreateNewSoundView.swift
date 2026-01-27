//
//  CreateNewSoundView.swift
//  RelaxOn
//
//  Created by Claude on 2025/01/26.
//

import SwiftUI
import UniformTypeIdentifiers

/// 새로운 사운드를 드래그 앤 드롭으로 제작하는 뷰
struct CreateNewSoundView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var customSoundViewModel: CustomSoundViewModel
    @StateObject private var viewModel = CreateSoundViewModel()
    @State private var isTargeted = false
    @State private var showSaveAlert = false
    @State private var soundTitle = ""
    @State private var isMixing = false
    @State private var mixingProgress: Float = 0.0
    @State private var showMixingOption = false
    @State private var editingSoundId: String? = nil
    @State private var ripples: [RippleEffect] = []
    @State private var rippleTimer: Timer? = nil

    var body: some View {
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        // 원본 사운드 섹션
                        originalSoundsSection()

                        // 배경음악 섹션
                        backgroundMusicSection()

                        // 볼륨 조절 섹션
                        if viewModel.selectedBackground != nil {
                            volumeControlSection()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, viewModel.addedSounds.isEmpty ? 20 : 120)
                }
                .frame(maxWidth: .infinity)
            }

            // 하단 플로팅 선택된 레이어
            if !viewModel.addedSounds.isEmpty {
                VStack {
                    Spacer()
                    floatingLayerBar()
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.addedSounds.count)
            }
        }
        .navigationTitle("새 사운드 만들기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showSaveAlert = true
                }) {
                    Text(L.Common.done.localized)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(viewModel.addedSounds.isEmpty ? Color(.Text).opacity(0.3) : Color(.PrimaryPurple))
                }
                .disabled(viewModel.addedSounds.isEmpty)
            }
        }
        .alert(L.Alert.soundName.localized, isPresented: $showSaveAlert) {
            TextField(L.Alert.enterName.localized, text: $soundTitle)
            Button(L.Common.cancel.localized, role: .cancel) { }
            Button(L.Common.save.localized) {
                saveSound()
            }
        } message: {
            Text(L.CreateSound.enterSoundName.localized)
        }
    }

    private func saveSound() {
        guard !viewModel.addedSounds.isEmpty else { return }

        // 재생 중인 오디오가 있다면 부드럽게 중지
        if customSoundViewModel.isPlaying {
            customSoundViewModel.stopSound()
            print("🔇 [CreateNewSound] 저장 전 오디오 중지")
        }

        let title = soundTitle.isEmpty ? "나만의 사운드" : soundTitle
        let mainSound = viewModel.addedSounds[0]

        // 여러 사운드 레이어 생성 (각 사운드의 커스텀 값 사용)
        let layers = viewModel.addedSounds.map { sound in
            CustomSound.SoundLayer(
                category: sound.category,
                filter: sound.filter,
                audioVariation: AudioVariation(
                    volume: sound.volume,
                    pitch: sound.pitch,
                    interval: sound.interval,
                    intervalVariation: sound.intervalVariation,
                    volumeVariation: sound.volumeVariation,
                    pitchVariation: sound.pitchVariation
                )
            )
        }

        // CustomSound 생성 (메인 사운드의 커스텀 값 사용)
        let newSound = CustomSound(
            title: title,
            category: mainSound.category,
            variation: AudioVariation(
                volume: mainSound.volume,
                pitch: mainSound.pitch,
                interval: mainSound.interval,
                intervalVariation: mainSound.intervalVariation,
                volumeVariation: mainSound.volumeVariation,
                pitchVariation: mainSound.pitchVariation
            ),
            filter: mainSound.filter,
            color: "",
            backgroundSound: viewModel.selectedBackground?.rawValue,
            backgroundVolume: viewModel.selectedBackground != nil ? viewModel.backgroundVolume : nil,
            soundLayers: layers.count > 1 ? layers : nil  // 2개 이상일 때만 레이어로 저장
        )

        print("✅ [CreateNewSound] 사운드 저장: \(title)")
        print("   - 레이어 수: \(layers.count)")
        print("   - 배경음: \(viewModel.selectedBackground?.rawValue ?? "없음")")

        // CustomSoundViewModel에 저장 (customSounds는 @Published이므로 append 시 자동으로 didSet 실행됨)
        customSoundViewModel.customSounds.append(newSound)

        // 화면 닫기
        soundTitle = ""
        dismiss()
    }


    // MARK: - Floating Layer Bar (하단 플로팅)
    @ViewBuilder
    private func floatingLayerBar() -> some View {
        VStack(spacing: 0) {
            // 커스터마이징 패널 (선택된 사운드)
            if let editingId = editingSoundId,
               let index = viewModel.addedSounds.firstIndex(where: { $0.id == editingId }) {
                soundCustomizePanel(index: index)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // 리플 시각화 + 사운드 칩
            ZStack {
                // 리플 배경
                rippleBackground()
                    .frame(height: 80)
                    .clipped()
                    .allowsHitTesting(false)

                // 사운드 칩들
                HStack(spacing: 8) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(viewModel.addedSounds) { sound in
                                floatingSoundChip(sound: sound)
                            }

                            // 배경음 표시
                            if let bg = viewModel.selectedBackground {
                                HStack(spacing: 4) {
                                    Image(systemName: bg.icon)
                                        .font(.system(size: 11))
                                        .foregroundColor(.white.opacity(0.9))
                                    Text(bg.rawValue)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(.white.opacity(0.9))
                                        .lineLimit(1)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.6))
                                .cornerRadius(16)
                            }
                        }
                    }

                    Spacer(minLength: 4)

                    // 레이어 수 뱃지
                    Text("\(viewModel.addedSounds.count)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(Color(.PrimaryPurple))
                        .clipShape(Circle())

                    // 초기화 버튼
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            editingSoundId = nil
                            viewModel.addedSounds.removeAll()
                            viewModel.selectedBackground = nil
                            stopRippleTimer()
                        }
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(.Text).opacity(0.6))
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: -4)
            )
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .onAppear { startRippleTimer() }
        .onDisappear { stopRippleTimer() }
        .onChange(of: viewModel.addedSounds.count) { _ in
            if viewModel.addedSounds.isEmpty { stopRippleTimer() }
            else { startRippleTimer() }
        }
    }

    // MARK: - Sound Chip (탭해서 커스터마이징 열기)
    @ViewBuilder
    private func floatingSoundChip(sound: AddedSound) -> some View {
        let isEditing = editingSoundId == sound.id
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                editingSoundId = isEditing ? nil : sound.id
            }
        }) {
            HStack(spacing: 4) {
                Image(systemName: sound.icon)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)

                Text(sound.name)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)

                if sound.isCustomized {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.8))
                }

                // 삭제
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if editingSoundId == sound.id { editingSoundId = nil }
                        viewModel.removeSound(sound)
                    }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(3)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(sound.color.opacity(isEditing ? 1.0 : 0.85))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(isEditing ? 0.8 : 0), lineWidth: 1.5)
            )
            .scaleEffect(isEditing ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Ripple Background
    @ViewBuilder
    private func rippleBackground() -> some View {
        GeometryReader { geo in
            ZStack {
                ForEach(ripples) { ripple in
                    RippleCircleView(ripple: ripple)
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }

    private func startRippleTimer() {
        stopRippleTimer()
        rippleTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            guard !viewModel.addedSounds.isEmpty else { return }
            let sound = viewModel.addedSounds.randomElement()!
            let screenWidth = UIScreen.main.bounds.width - 48
            let newRipple = RippleEffect(
                position: CGPoint(
                    x: CGFloat.random(in: 20...(screenWidth - 20)),
                    y: CGFloat.random(in: 15...65)
                ),
                color: sound.color,
                size: CGFloat(sound.volume) * 40 + 20
            )
            withAnimation(.easeOut(duration: 0.3)) {
                ripples.append(newRipple)
            }
            // 오래된 리플 제거
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                ripples.removeAll { $0.id == newRipple.id }
            }
        }
    }

    private func stopRippleTimer() {
        rippleTimer?.invalidate()
        rippleTimer = nil
        ripples.removeAll()
    }

    // MARK: - Per-Sound Customize Panel
    @ViewBuilder
    private func soundCustomizePanel(index: Int) -> some View {
        let sound = viewModel.addedSounds[index]

        VStack(spacing: 12) {
            // 헤더
            HStack {
                Image(systemName: sound.icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(sound.color)
                ZStack {
                    Text(sound.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(.TitleText))
                }
                Spacer()
                Button(action: {
                    withAnimation { editingSoundId = nil }
                }) {
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(Color(.Text).opacity(0.3))
                }
            }

            // 볼륨
            compactSlider(
                icon: "speaker.wave.2.fill",
                label: L.Customize.volume.localized,
                value: Binding(
                    get: { viewModel.addedSounds[index].volume },
                    set: { viewModel.addedSounds[index].volume = $0; viewModel.addedSounds[index].isCustomized = true }
                ),
                range: 0.1...1.0,
                step: 0.05,
                displayValue: String(format: "%.0f%%", viewModel.addedSounds[index].volume * 100),
                color: .green,
                variationValue: Binding(
                    get: { viewModel.addedSounds[index].volumeVariation },
                    set: { viewModel.addedSounds[index].volumeVariation = $0; viewModel.addedSounds[index].isCustomized = true }
                )
            )

            // 간격
            compactSlider(
                icon: "timer",
                label: L.Customize.interval.localized,
                value: Binding(
                    get: { viewModel.addedSounds[index].interval },
                    set: { viewModel.addedSounds[index].interval = $0; viewModel.addedSounds[index].isCustomized = true }
                ),
                range: 0.1...3.0,
                step: 0.1,
                displayValue: String(format: "%.1f%@", viewModel.addedSounds[index].interval, L.Customize.seconds.localized),
                color: .blue,
                variationValue: Binding(
                    get: { viewModel.addedSounds[index].intervalVariation },
                    set: { viewModel.addedSounds[index].intervalVariation = $0; viewModel.addedSounds[index].isCustomized = true }
                )
            )

            // 피치
            compactSlider(
                icon: "tuningfork",
                label: L.Customize.pitch.localized,
                value: Binding(
                    get: { viewModel.addedSounds[index].pitch },
                    set: { viewModel.addedSounds[index].pitch = $0; viewModel.addedSounds[index].isCustomized = true }
                ),
                range: -5.0...5.0,
                step: 0.5,
                displayValue: String(format: "%+.1f", viewModel.addedSounds[index].pitch),
                color: .orange,
                variationValue: Binding(
                    get: { viewModel.addedSounds[index].pitchVariation },
                    set: { viewModel.addedSounds[index].pitchVariation = $0; viewModel.addedSounds[index].isCustomized = true }
                )
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -2)
        )
        .padding(.horizontal, 12)
        .padding(.bottom, 4)
    }

    // MARK: - Compact Slider (커스터마이징 패널용)
    @ViewBuilder
    private func compactSlider(
        icon: String,
        label: String,
        value: Binding<Float>,
        range: ClosedRange<Float>,
        step: Float,
        displayValue: String,
        color: Color,
        variationValue: Binding<Float>
    ) -> some View {
        VStack(spacing: 6) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(color)
                    .frame(width: 18)

                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(.Text))

                Spacer()

                Text(displayValue)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(color)
                    .frame(minWidth: 45, alignment: .trailing)
            }

            Slider(value: value, in: range, step: step)
                .tint(color)

            // 변동폭
            HStack(spacing: 6) {
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 10))
                    .foregroundColor(color.opacity(0.6))

                Text(L.Customize.variationRange.localized)
                    .font(.system(size: 10))
                    .foregroundColor(Color(.Text).opacity(0.6))

                Spacer()

                Text(String(format: "±%.0f%%", variationValue.wrappedValue * 100))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(color.opacity(0.7))
            }

            Slider(value: variationValue, in: 0.0...0.5, step: 0.05)
                .tint(color.opacity(0.5))
        }
        .padding(10)
        .background(Color(.DefaultBackground).opacity(0.5))
        .cornerRadius(10)
    }

    // MARK: - Original Sounds Section (카테고리별 정리)
    @ViewBuilder
    private func originalSoundsSection() -> some View {
        VStack(spacing: 16) {
            // 헤더
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.CreateSound.originalSounds.localized)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(.TitleText))

                    HStack(spacing: 6) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 11))
                        Text(L.CreateSound.tapToSelectMultiple.localized)
                            .font(.system(size: 11))
                    }
                    .foregroundColor(Color(.Text).opacity(0.5))
                }

                Spacer()
            }

            // 카테고리별 사운드
            ForEach(SoundCategory.allCases.filter { $0 != .none }, id: \.self) { category in
                let categorySounds = viewModel.availableSounds.filter { $0.category == category }
                if !categorySounds.isEmpty {
                    soundCategorySection(category: category, sounds: categorySounds)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Sound Category Section
    @ViewBuilder
    private func soundCategorySection(category: SoundCategory, sounds: [AvailableSound]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // 카테고리 헤더
            HStack(spacing: 6) {
                Image(systemName: category.iconName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(category.themeColor)

                Text(category.displayName)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(category.themeColor)

                Rectangle()
                    .fill(category.themeColor.opacity(0.2))
                    .frame(height: 1)
            }

            // 사운드 그리드 (4열)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ],
                spacing: 8
            ) {
                ForEach(sounds) { sound in
                    CompactSoundCard(
                        sound: sound,
                        isSelected: viewModel.isSoundAdded(sound)
                    ) {
                        viewModel.toggleSound(sound)
                    }
                }
            }
        }
    }

    // MARK: - Background Music Section
    @ViewBuilder
    private func backgroundMusicSection() -> some View {
        VStack(spacing: 16) {
            // 헤더
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.CreateSound.backgroundMusic.localized)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(.TitleText))

                    Text(L.CreateSound.optionalAmbience.localized)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.Text).opacity(0.5))
                }

                Spacer()

                if viewModel.selectedBackground != nil {
                    Button(action: {
                        withAnimation {
                            viewModel.selectedBackground = nil
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                            Text(L.CreateSound.deselect.localized)
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }

            // 그리드
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(BackgroundSound.allCases, id: \.self) { background in
                    BackgroundMusicCard(
                        background: background,
                        isSelected: viewModel.selectedBackground == background
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.selectedBackground = background
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

    // MARK: - Volume Control Section
    @ViewBuilder
    private func volumeControlSection() -> some View {
        VStack(spacing: 16) {
            // 헤더
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(.PrimaryPurple))

                Text(L.CreateSound.backgroundMusicVolume.localized)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(.TitleText))

                Spacer()

                Text("\(Int(viewModel.backgroundVolume * 100))%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.PrimaryPurple))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color(.PrimaryPurple).opacity(0.1))
                    .cornerRadius(12)
            }

            // 슬라이더
            VStack(spacing: 8) {
                Slider(value: $viewModel.backgroundVolume, in: 0...1)
                    .tint(Color(.PrimaryPurple))

                HStack {
                    Text(L.Common.quiet.localized)
                        .font(.system(size: 11))
                        .foregroundColor(Color(.Text).opacity(0.4))
                    Spacer()
                    Text(L.Common.loud.localized)
                        .font(.system(size: 11))
                        .foregroundColor(Color(.Text).opacity(0.4))
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }

}

// MARK: - Background Music Card

struct BackgroundMusicCard: View {
    let background: BackgroundSound
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: background.colors.map { $0.opacity(isSelected ? 1.5 : 1.0) }),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: background.icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .white : Color(.TitleText))
                }

                // 이름
                Text(background.rawValue)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? Color(.PrimaryPurple) : Color(.TitleText))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(
                        color: isSelected ? Color(.PrimaryPurple).opacity(0.3) : Color.black.opacity(0.06),
                        radius: isSelected ? 6 : 3,
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(.PrimaryPurple) : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Compact Sound Card (4열 그리드용)

struct CompactSoundCard: View {
    let sound: AvailableSound
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                                ? sound.color
                                : sound.color.opacity(0.15)
                        )
                        .frame(width: 36, height: 36)

                    Image(systemName: sound.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isSelected ? .white : sound.color)

                    if isSelected {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 36, height: 36)
                    }
                }

                Text(sound.name)
                    .font(.system(size: 9, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? sound.color : Color(.TitleText))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 2)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? sound.color.opacity(0.1) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? sound.color.opacity(0.5) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Original Sound Card

struct OriginalSoundCard: View {
    let sound: AvailableSound
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                                ? sound.color.opacity(0.25)
                                : sound.color.opacity(0.15)
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: sound.icon)
                        .font(.system(size: 22))
                        .foregroundColor(isSelected ? .white : sound.color)

                    // 선택 표시 체크마크
                    if isSelected {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .background(
                                        Circle()
                                            .fill(sound.color)
                                            .frame(width: 18, height: 18)
                                    )
                            }
                            Spacer()
                        }
                        .frame(width: 48, height: 48)
                    }
                }

                // 이름
                Text(sound.name)
                    .font(.system(size: 11, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? sound.color : Color(.TitleText))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(
                        color: isSelected ? sound.color.opacity(0.3) : (isPressed ? sound.color.opacity(0.3) : Color.black.opacity(0.06)),
                        radius: isSelected ? 8 : (isPressed ? 6 : 3),
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? sound.color : sound.color.opacity(isPressed ? 0.4 : 0.0),
                        lineWidth: isSelected ? 2.5 : 2
                    )
            )
            .scaleEffect(isSelected ? 1.05 : (isPressed ? 0.95 : 1.0))
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - View Models

class CreateSoundViewModel: ObservableObject {
    @Published var availableSounds: [AvailableSound] = []
    @Published var addedSounds: [AddedSound] = []
    @Published var selectedSound: AddedSound?
    @Published var selectedBackground: BackgroundSound?
    @Published var backgroundVolume: Float = 0.3
    @Published var shouldMixAudio: Bool = true // 기본값: 믹싱

    init() {
        loadAvailableSounds()
    }

    private func loadAvailableSounds() {
        availableSounds = [
            // MARK: - WaterDrop 카테고리
            AvailableSound(
                id: "waterdrop",
                name: AudioFilter.WaterDrop.displayName,
                icon: "drop.fill",
                color: .blue,
                category: .WaterDrop,
                filter: .WaterDrop,
                duration: 1.0
            ),
            AvailableSound(
                id: "basement",
                name: AudioFilter.Basement.displayName,
                icon: "building.fill",
                color: .cyan,
                category: .WaterDrop,
                filter: .Basement,
                duration: 2.0
            ),
            AvailableSound(
                id: "cave",
                name: AudioFilter.Cave.displayName,
                icon: "moon.fill",
                color: .indigo,
                category: .WaterDrop,
                filter: .Cave,
                duration: 1.5
            ),
            AvailableSound(
                id: "pipe",
                name: AudioFilter.Pipe.displayName,
                icon: "cylinder.fill",
                color: .teal,
                category: .WaterDrop,
                filter: .Pipe,
                duration: 1.2
            ),
            AvailableSound(
                id: "sink",
                name: AudioFilter.Sink.displayName,
                icon: "rectangle.fill",
                color: .mint,
                category: .WaterDrop,
                filter: .Sink,
                duration: 1.8
            ),

            // MARK: - SingingBowl 카테고리
            AvailableSound(
                id: "bowl",
                name: AudioFilter.SingingBowl.displayName,
                icon: "circle.circle",
                color: .purple,
                category: .SingingBowl,
                filter: .SingingBowl,
                duration: 3.0
            ),
            AvailableSound(
                id: "focus",
                name: AudioFilter.Focus.displayName,
                icon: "scope",
                color: .purple.opacity(0.8),
                category: .SingingBowl,
                filter: .Focus,
                duration: 2.5
            ),
            AvailableSound(
                id: "training",
                name: AudioFilter.Training.displayName,
                icon: "figure.mind.and.body",
                color: .purple.opacity(0.7),
                category: .SingingBowl,
                filter: .Training,
                duration: 3.0
            ),
            AvailableSound(
                id: "empty",
                name: AudioFilter.Empty.displayName,
                icon: "circle.dashed",
                color: .purple.opacity(0.6),
                category: .SingingBowl,
                filter: .Empty,
                duration: 2.8
            ),
            AvailableSound(
                id: "vibration",
                name: AudioFilter.Vibration.displayName,
                icon: "waveform",
                color: .purple.opacity(0.9),
                category: .SingingBowl,
                filter: .Vibration,
                duration: 3.2
            ),
            AvailableSound(
                id: "tibetanbowl",
                name: AudioFilter.TibetanBowl.displayName,
                icon: "circle.hexagongrid.fill",
                color: .orange,
                category: .SingingBowl,
                filter: .TibetanBowl,
                duration: 3.5
            ),
            AvailableSound(
                id: "bell",
                name: AudioFilter.Bell.displayName,
                icon: "bell.fill",
                color: .yellow,
                category: .SingingBowl,
                filter: .Bell,
                duration: 2.0
            ),
            AvailableSound(
                id: "bowldeep",
                name: AudioFilter.BowlDeep.displayName,
                icon: "circle.circle.fill",
                color: .purple,
                category: .SingingBowl,
                filter: .BowlDeep,
                duration: 4.0
            ),
            AvailableSound(
                id: "bowlloud",
                name: AudioFilter.BowlLoud.displayName,
                icon: "speaker.wave.3.fill",
                color: .purple.opacity(0.85),
                category: .SingingBowl,
                filter: .BowlLoud,
                duration: 3.5
            ),

            // MARK: - Bird 카테고리
            AvailableSound(
                id: "bird",
                name: AudioFilter.Bird.displayName,
                icon: "bird.fill",
                color: .green,
                category: .Bird,
                filter: .Bird,
                duration: 2.5
            ),
            AvailableSound(
                id: "owl",
                name: AudioFilter.Owl.displayName,
                icon: "moon.stars.fill",
                color: .brown,
                category: .Bird,
                filter: .Owl,
                duration: 2.0
            ),
            AvailableSound(
                id: "woodpecker",
                name: AudioFilter.Woodpecker.displayName,
                icon: "leaf.fill",
                color: .orange,
                category: .Bird,
                filter: .Woodpecker,
                duration: 0.8
            ),
            AvailableSound(
                id: "forest",
                name: AudioFilter.Forest.displayName,
                icon: "tree.fill",
                color: .green.opacity(0.8),
                category: .Bird,
                filter: .Forest,
                duration: 3.0
            ),
            AvailableSound(
                id: "cuckoo",
                name: AudioFilter.Cuckoo.displayName,
                icon: "sun.max.fill",
                color: .yellow,
                category: .Bird,
                filter: .Cuckoo,
                duration: 1.5
            ),
            AvailableSound(
                id: "jungle",
                name: AudioFilter.Jungle.displayName,
                icon: "leaf.arrow.triangle.circlepath",
                color: .green,
                category: .Bird,
                filter: .Jungle,
                duration: 4.0
            ),
            AvailableSound(
                id: "forestbird",
                name: AudioFilter.ForestBird.displayName,
                icon: "bird",
                color: .green.opacity(0.7),
                category: .Bird,
                filter: .ForestBird,
                duration: 3.5
            ),
            AvailableSound(
                id: "springforest",
                name: AudioFilter.SpringForest.displayName,
                icon: "sun.haze.fill",
                color: .mint,
                category: .Bird,
                filter: .SpringForest,
                duration: 5.0
            ),

            // MARK: - Rain 카테고리
            AvailableSound(
                id: "softrain",
                name: AudioFilter.SoftRain.displayName,
                icon: "cloud.drizzle.fill",
                color: .cyan,
                category: .Rain,
                filter: .SoftRain,
                duration: 6.0
            ),
            AvailableSound(
                id: "cityrain",
                name: AudioFilter.CityRain.displayName,
                icon: "cloud.rain.fill",
                color: .blue,
                category: .Rain,
                filter: .CityRain,
                duration: 5.0
            ),
            AvailableSound(
                id: "rainmaker",
                name: AudioFilter.RainMaker.displayName,
                icon: "cloud.heavyrain.fill",
                color: .blue.opacity(0.8),
                category: .Rain,
                filter: .RainMaker,
                duration: 4.0
            ),

            // MARK: - Ambient 카테고리
            AvailableSound(
                id: "ambientkeys",
                name: AudioFilter.AmbientKeys.displayName,
                icon: "pianokeys",
                color: .indigo,
                category: .Ambient,
                filter: .AmbientKeys,
                duration: 8.0
            ),
            AvailableSound(
                id: "underwater",
                name: AudioFilter.Underwater.displayName,
                icon: "water.waves",
                color: .cyan.opacity(0.8),
                category: .Ambient,
                filter: .Underwater,
                duration: 6.0
            ),
            AvailableSound(
                id: "meditationpad",
                name: AudioFilter.MeditationPad.displayName,
                icon: "sparkles",
                color: .purple.opacity(0.6),
                category: .Ambient,
                filter: .MeditationPad,
                duration: 10.0
            ),
            AvailableSound(
                id: "atmosphere",
                name: AudioFilter.Atmosphere.displayName,
                icon: "waveform.path",
                color: .indigo.opacity(0.7),
                category: .Ambient,
                filter: .Atmosphere,
                duration: 8.0
            ),
            AvailableSound(
                id: "indigomusic",
                name: AudioFilter.IndigoMusic.displayName,
                icon: "music.note",
                color: .indigo,
                category: .Ambient,
                filter: .IndigoMusic,
                duration: 7.0
            ),

            // MARK: - ASMR 카테고리
            AvailableSound(
                id: "keyboard",
                name: AudioFilter.Keyboard.displayName,
                icon: "keyboard.fill",
                color: .pink,
                category: .ASMR,
                filter: .Keyboard,
                duration: 2.0
            ),
            AvailableSound(
                id: "camera",
                name: AudioFilter.Camera.displayName,
                icon: "camera.fill",
                color: .pink.opacity(0.8),
                category: .ASMR,
                filter: .Camera,
                duration: 1.0
            )
        ]
    }

    func toggleSound(_ sound: AvailableSound) {
        // 이미 추가된 사운드인지 확인
        if let existingIndex = addedSounds.firstIndex(where: { $0.filter == sound.filter }) {
            // 이미 추가되어 있으면 제거
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                addedSounds.remove(at: existingIndex)
            }
            print("🔄 [CreateSoundViewModel] 사운드 제거: \(sound.name)")
        } else {
            // 추가되어 있지 않으면 추가
            let newSound = AddedSound(
                id: UUID().uuidString,
                name: sound.name,
                icon: sound.icon,
                color: sound.color,
                category: sound.category,
                filter: sound.filter,
                isCustomized: false
            )

            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                addedSounds.append(newSound)
            }
            print("✅ [CreateSoundViewModel] 사운드 추가: \(sound.name)")
        }
    }

    /// 사운드가 이미 추가되었는지 확인
    func isSoundAdded(_ sound: AvailableSound) -> Bool {
        return addedSounds.contains(where: { $0.filter == sound.filter })
    }

    func removeSound(_ sound: AddedSound) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            addedSounds.removeAll { $0.id == sound.id }
        }
    }

    func selectSoundForEdit(_ sound: AddedSound) {
        selectedSound = sound
        // 여기서 커스터마이징 뷰로 이동
    }
}

// MARK: - Data Models

struct AvailableSound: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let category: SoundCategory
    let filter: AudioFilter
    let duration: TimeInterval
}

struct AddedSound: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let category: SoundCategory
    let filter: AudioFilter
    var isCustomized: Bool

    // Customization values
    var volume: Float = 1.0
    var pitch: Float = 0.0
    var interval: Float = 1.0
    var intervalVariation: Float = 0.0
    var volumeVariation: Float = 0.0
    var pitchVariation: Float = 0.0
}

// MARK: - Ripple Effect
struct RippleEffect: Identifiable {
    let id = UUID()
    let position: CGPoint
    let color: Color
    let size: CGFloat
    let createdAt = Date()
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            let position = result.positions[index]
            subview.place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: .unspecified
            )
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

// MARK: - Ripple Circle Animation

struct RippleCircleView: View {
    let ripple: RippleEffect
    @State private var scale: CGFloat = 0.3
    @State private var opacity: Double = 0.6

    var body: some View {
        Circle()
            .stroke(ripple.color.opacity(0.4), lineWidth: 1.5)
            .frame(width: ripple.size, height: ripple.size)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(ripple.position)
            .onAppear {
                withAnimation(.easeOut(duration: 2.0)) {
                    scale = 2.5
                    opacity = 0.0
                }
            }
    }
}

// MARK: - Preview

struct CreateNewSoundView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateNewSoundView()
        }
    }
}
