//
//  SoundListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI
import Combine

/**
 앱에 저장된 Original Sound 정보들이 그리드 뷰 형태의 리스트로 나열된 Main View
 */
struct SoundListView: View {

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.DefaultBackground)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(L.SoundList.title.localized)
                            .foregroundColor(Color(.TitleText))
                            .font(.system(size: 24, weight: .bold))

                        Spacer()

                        // 새 사운드 만들기 버튼
                        NavigationLink(destination: CreateNewSoundView().environmentObject(viewModel)) {
                            HStack(spacing: 4) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 14))
                                Text(L.SoundList.createNew.localized)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.PrimaryPurple))
                            .cornerRadius(8)
                        }

                        // 샘플 데이터 생성 버튼
                        Button(action: {
                            viewModel.createSampleData()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "wand.and.stars")
                                    .font(.system(size: 14))
                                Text(L.SoundList.sample.localized)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.PrimaryPurple).opacity(0.7))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 4)
                    
                    SearchBar(text: $searchText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // 추천 프리셋 섹션
                            if searchText.isEmpty {
                                recommendedSection()
                            }

                            // 기존 사운드 그리드
                            gridView()
                        }
                    }
                }

                .navigationDestination(
                    isPresented: $appState.showSoundDetail) {
                        SoundDetailView(isTutorial: false, originalSound: OriginalSound(name: AudioFilter.WaterDrop.displayName, filter: .WaterDrop, category: .WaterDrop))
                    }
            }
        }

    }
    
    @ViewBuilder
    private func recommendedSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(Color(.PrimaryPurple))
                    .font(.system(size: 16))
                Text(L.SoundList.recommended.localized)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(.TitleText))
            }
            .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Preset.recommended) { preset in
                        NavigationLink(destination: presetDetailView(preset: preset)) {
                            presetCard(preset: preset)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }

    @ViewBuilder
    private func presetCard(preset: Preset) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(preset.category.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 140, height: 100)
                .background(Color(hex: preset.color))
                .cornerRadius(8)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(preset.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(.Text))
                    .lineLimit(1)

                Text(preset.description)
                    .font(.system(size: 11))
                    .foregroundColor(Color(.Text).opacity(0.6))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 140)
        }
        .frame(width: 140)
    }

    @ViewBuilder
    private func presetDetailView(preset: Preset) -> some View {
        SoundDetailView(
            isTutorial: false,
            originalSound: preset.toOriginalSound(),
            presetVariation: preset.audioVariation
        )
    }

    @ViewBuilder
    private func gridView() -> some View {

        VStack(alignment: .leading, spacing: 12) {
            Text(L.SoundList.originalSounds.localized)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(.TitleText))
                .padding(.horizontal, 24)

            LazyVGrid(columns: columns) {
                ForEach(filteredSounds(), id: \.self) { originalSound in
                    NavigationLink(destination: SoundDetailView(isTutorial: false, originalSound: originalSound)) {
                        gridViewItem(originalSound)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
        }
    }
    
    @ViewBuilder
    private func gridViewItem(_ originalSound: OriginalSound) -> some View {
        
        VStack(alignment: .leading) {
            
            Text(originalSound.category.displayName)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.Text))
            
            Image(originalSound.category.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 140)
                .background(Color(hex: originalSound.color))
                .cornerRadius(8)
        }
    }
    
    private func filteredSounds() -> [OriginalSound] {
        if searchText.isEmpty {
            return SoundListView.originalSounds
        } else {
            return SoundListView.originalSounds.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
    }
}

// MARK: - Create New Sound View

/// 새로운 사운드를 드래그 앤 드롭으로 제작하는 뷰
struct CreateNewSoundView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CreateSoundViewModel()
    @State private var showingSaveAlert = false
    @State private var soundTitle = ""
    @State private var waveAnimationTrigger = false

    var body: some View {
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text(L.CreateSound.back.localized)
                                .font(.system(size: 16))
                        }
                        .foregroundColor(Color(.PrimaryPurple))
                    }

                    Spacer()

                    Text(L.CreateSound.title.localized)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(.TitleText))

                    Spacer()

                    Button(action: {
                        showingSaveAlert = true
                    }) {
                        Text(L.CreateSound.create.localized)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(viewModel.selectedOriginalSound == nil ? Color(.Text).opacity(0.3) : Color(.PrimaryPurple))
                    }
                    .disabled(viewModel.selectedOriginalSound == nil)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color(.DefaultBackground))

                // 사운드 캔버스 (고정)
                emptyCanvasView()
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 16)

                // 배경 사운드와 원본 사운드만 스크롤
                ScrollView {
                    VStack(spacing: 24) {
                        // 배경 사운드 선택 영역
                        backgroundSoundSection()
                            .padding(.top, 16)

                        // 원본 사운드 선택 영역
                        dropZoneView()

                        // 커스터마이징 섹션 (원본 사운드 선택 시 표시)
                        if viewModel.selectedOriginalSound != nil {
                            customizationSection()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .alert(L.Alert.soundName.localized, isPresented: $showingSaveAlert) {
            TextField(L.Alert.enterName.localized, text: $soundTitle)
            Button(L.Common.cancel.localized, role: .cancel) {
                soundTitle = ""
            }
            Button(L.Common.save.localized) {
                if !soundTitle.isEmpty {
                    if viewModel.saveCustomSound(title: soundTitle) {
                        dismiss()
                    } else {
                        // 저장 실패 처리 (예: 중복된 이름)
                        soundTitle = ""
                    }
                }
            }
        } message: {
            Text(L.Alert.enterDescription.localized)
        }
        .onDisappear {
            viewModel.stopPreview()
        }
    }

    @ViewBuilder
    private func emptyCanvasView() -> some View {
        VStack(spacing: 16) {
            Text(L.CreateSound.canvasTitle.localized)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.Text).opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)

            ZStack {
                // 배경 그라데이션 (배경 사운드에 따라 변경)
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: viewModel.selectedBackground?.colors ?? [
                                Color(.PrimaryPurple).opacity(0.05),
                                Color.blue.opacity(0.03)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .animation(.easeInOut(duration: 0.5), value: viewModel.selectedBackground)

                // 사운드 시각화
                VStack(spacing: 12) {
                    if viewModel.selectedOriginalSound != nil {
                        // 실시간 물방울 시각화 (오디오와 싱크)
                        SoundCanvasVisualization(viewModel: viewModel)
                    } else {
                        // 빈 캔버스
                        ZStack {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .stroke(
                                        Color.blue.opacity(0.15 - Double(index) * 0.05),
                                        style: StrokeStyle(lineWidth: 2, dash: [5, 5])
                                    )
                                    .frame(width: CGFloat(60 + index * 40), height: CGFloat(60 + index * 40))
                            }
                        }
                        .frame(height: 240)
                    }

                    VStack(spacing: 6) {
                        if let background = viewModel.selectedBackground, let original = viewModel.selectedOriginalSound {
                            Text(String(format: L.CreateSound.combinedFormat.localized, background.displayName, original.name))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(.TitleText))

                            Text(L.CreateSound.playing.localized)
                                .font(.system(size: 13))
                                .foregroundColor(Color(.PrimaryPurple))
                        } else if let background = viewModel.selectedBackground {
                            Text(background.displayName)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(.TitleText))

                            Text(L.CreateSound.selectOriginal.localized)
                                .font(.system(size: 13))
                                .foregroundColor(Color(.Text).opacity(0.5))
                        } else if let original = viewModel.selectedOriginalSound {
                            Text(original.name)
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color(.TitleText))

                            Text(L.CreateSound.playing.localized)
                                .font(.system(size: 13))
                                .foregroundColor(Color(.PrimaryPurple))
                        } else {
                            Text(L.CreateSound.selectBoth.localized)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(.Text).opacity(0.5))

                            Text(L.CreateSound.canPlayNow.localized)
                                .font(.system(size: 13))
                                .foregroundColor(Color(.Text).opacity(0.4))
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .frame(height: 280)
        }
    }

    @ViewBuilder
    private func backgroundSoundSection() -> some View {
        VStack(spacing: 16) {
            HStack {
                Text(L.CreateSound.backgroundSound.localized)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.Text).opacity(0.6))

                Spacer()

                if viewModel.selectedBackground != nil {
                    Button(action: {
                        viewModel.clearBackground()
                    }) {
                        Text(L.Common.remove.localized)
                            .font(.system(size: 12))
                            .foregroundColor(.red.opacity(0.8))
                    }
                }
            }

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(BackgroundSound.allCases, id: \.self) { background in
                    BackgroundSoundCard(
                        background: background,
                        isSelected: viewModel.selectedBackground == background
                    ) {
                        viewModel.selectBackground(background)
                    }
                }
            }

            // 배경음 볼륨 슬라이더 (배경음이 선택되었을 때만 표시)
            if viewModel.selectedBackground != nil {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "speaker.wave.1.fill")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.Text).opacity(0.6))

                        Text(L.CreateSound.backgroundVolume.localized)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(.Text).opacity(0.6))

                        Spacer()

                        Text("\(Int(viewModel.backgroundVolume * 100))%")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(Color(.PrimaryPurple))
                            .frame(width: 40, alignment: .trailing)
                    }

                    HStack(spacing: 12) {
                        Image(systemName: "speaker.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.Text).opacity(0.4))

                        Slider(value: $viewModel.backgroundVolume, in: 0.0...1.0)
                            .accentColor(Color(.PrimaryPurple))

                        Image(systemName: "speaker.wave.3.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.Text).opacity(0.4))
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.selectedBackground)
            }
        }
    }

    @ViewBuilder
    private func dropZoneView() -> some View {
        VStack(spacing: 16) {
            Text(L.CreateSound.originalSoundSelection.localized)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.Text).opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(viewModel.availableSounds) { sound in
                    OriginalSoundCard(
                        sound: sound,
                        isSelected: viewModel.selectedOriginalSound?.id == sound.id
                    ) {
                        viewModel.playPreview(sound: sound)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func customizationSection() -> some View {
        VStack(spacing: 16) {
            HStack {
                if let sound = viewModel.selectedOriginalSound {
                    HStack(spacing: 8) {
                        Image(systemName: sound.icon)
                            .font(.system(size: 16))
                            .foregroundColor(sound.color)

                        Text("\(sound.name) \(L.CreateSound.customizing.localized)")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(.Text))
                    }
                }

                Spacer()

                Button(action: {
                    if let sound = viewModel.selectedOriginalSound {
                        viewModel.soundVariations[sound.id] = AudioVariation()
                        viewModel.playPreview(sound: sound)
                    }
                }) {
                    Text(L.Common.reset.localized)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.PrimaryPurple).opacity(0.8))
                }
            }

            VStack(spacing: 16) {
                // 볼륨 슬라이더 (변동성 포함)
                variationSlider(
                    icon: "speaker.wave.2.fill",
                    label: L.Customize.volume.localized,
                    value: Binding(
                        get: { viewModel.currentVariation.volume },
                        set: { var v = viewModel.currentVariation; v.volume = $0; viewModel.currentVariation = v }
                    ),
                    variationValue: Binding(
                        get: { viewModel.currentVariation.volumeVariation },
                        set: { var v = viewModel.currentVariation; v.volumeVariation = $0; viewModel.currentVariation = v }
                    ),
                    range: 0.1...1.0,
                    color: .green,
                    unit: "%"
                )

                // 피치 슬라이더 (변동성 포함)
                variationSlider(
                    icon: "waveform",
                    label: L.Customize.pitch.localized,
                    value: Binding(
                        get: { viewModel.currentVariation.pitch },
                        set: { var v = viewModel.currentVariation; v.pitch = $0; viewModel.currentVariation = v }
                    ),
                    variationValue: Binding(
                        get: { viewModel.currentVariation.pitchVariation },
                        set: { var v = viewModel.currentVariation; v.pitchVariation = $0; viewModel.currentVariation = v }
                    ),
                    range: -12.0...12.0,
                    color: .purple,
                    unit: ""
                )

                // 간격 슬라이더 (변동성 포함)
                variationSlider(
                    icon: "timer",
                    label: L.Customize.interval.localized,
                    value: Binding(
                        get: { viewModel.currentVariation.interval },
                        set: { var v = viewModel.currentVariation; v.interval = $0; viewModel.currentVariation = v }
                    ),
                    variationValue: Binding(
                        get: { viewModel.currentVariation.intervalVariation },
                        set: { var v = viewModel.currentVariation; v.intervalVariation = $0; viewModel.currentVariation = v }
                    ),
                    range: 0.1...5.0,
                    color: .orange,
                    unit: L.Customize.seconds.localized
                )
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .transition(.opacity.combined(with: .move(edge: .bottom)))
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.selectedOriginalSound)
    }

    // 변동성 포함 슬라이더
    @ViewBuilder
    private func variationSlider(
        icon: String,
        label: String,
        value: Binding<Float>,
        variationValue: Binding<Float>,
        range: ClosedRange<Float>,
        color: Color,
        unit: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(color)
                    .frame(width: 20)

                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.Text))

                Spacer()

                if unit == "%" {
                    Text("\(Int(value.wrappedValue * 100))\(unit)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(color)
                } else if unit == L.Customize.seconds.localized {
                    Text(String(format: "%.2f%@", value.wrappedValue, unit))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(color)
                } else {
                    Text(String(format: "%.1f", value.wrappedValue))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(color)
                }
            }

            Slider(value: value, in: range)
                .tint(color)

            // 변동폭 슬라이더
            Divider()
                .padding(.vertical, 4)

            HStack {
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 12))
                    .foregroundColor(color.opacity(0.7))
                    .frame(width: 20)

                Text(L.Customize.variation.localized)
                    .font(.system(size: 12))
                    .foregroundColor(Color(.Text).opacity(0.8))

                Spacer()

                VariationIndicator(value: variationValue.wrappedValue, color: color)

                Text(String(format: "±%.0f%%", variationValue.wrappedValue * 100))
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(color.opacity(0.7))
                    .frame(minWidth: 40, alignment: .trailing)
            }

            Slider(value: variationValue, in: 0.0...0.5, step: 0.05)
                .tint(color.opacity(0.6))

            // 범위 시각화 바
            if variationValue.wrappedValue > 0 {
                VariationRangeBar(
                    baseValue: value.wrappedValue,
                    variation: variationValue.wrappedValue,
                    range: range,
                    color: color,
                    unit: unit
                )
                .padding(.top, 4)
            }
        }
        .padding(12)
        .background(Color(.CircularSliderBackground).opacity(0.3))
        .cornerRadius(10)
    }
}

struct OriginalSoundCard: View {
    let sound: AvailableSound
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(sound.color.opacity(isSelected ? 0.3 : 0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: sound.icon)
                        .font(.system(size: 22))
                        .foregroundColor(sound.color)

                    // 재생 중 표시
                    if isSelected {
                        Circle()
                            .stroke(sound.color, lineWidth: 2)
                            .frame(width: 50, height: 50)
                    }
                }

                Text(sound.name)
                    .font(.system(size: 12, weight: isSelected ? .bold : .medium))
                    .foregroundColor(Color(.TitleText))
                    .lineLimit(1)

                Text(String(format: "%.1fs", sound.duration))
                    .font(.system(size: 10))
                    .foregroundColor(Color(.Text).opacity(0.5))
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(
                        color: isPressed || isSelected ? sound.color.opacity(0.3) : Color.black.opacity(0.06),
                        radius: isPressed || isSelected ? 8 : 4,
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(sound.color.opacity(isSelected ? 0.6 : (isPressed ? 0.4 : 0.0)), lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct BackgroundSoundCard: View {
    let background: BackgroundSound
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            isSelected
                                ? LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(.PrimaryPurple).opacity(0.3),
                                        Color(.PrimaryPurple).opacity(0.15)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.gray.opacity(0.15),
                                        Color.gray.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                        )
                        .frame(width: 60, height: 60)

                    Image(systemName: background.icon)
                        .font(.system(size: 26))
                        .foregroundColor(isSelected ? Color(.PrimaryPurple) : .gray)
                }

                Text(background.displayName)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? Color(.PrimaryPurple) : Color(.TitleText))
                    .lineLimit(1)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(
                        color: isPressed ? Color(.PrimaryPurple).opacity(0.3) : Color.black.opacity(0.06),
                        radius: isPressed ? 8 : 4,
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color(.PrimaryPurple).opacity(0.5) : Color.clear,
                        lineWidth: 2
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct AddedSoundRow: View {
    let sound: AddedSound
    let index: Int
    let onTap: () -> Void
    let onRemove: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Text("\(index + 1)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(sound.color)
                    )

                HStack(spacing: 12) {
                    Image(systemName: sound.icon)
                        .font(.system(size: 18))
                        .foregroundColor(sound.color)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(sound.name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(.TitleText))

                        if sound.isCustomized {
                            HStack(spacing: 4) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 10))
                                Text(L.Common.customized.localized)
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(Color(.PrimaryPurple).opacity(0.8))
                        } else {
                            Text(L.Common.tapToCustomize.localized)
                                .font(.system(size: 11))
                                .foregroundColor(Color(.Text).opacity(0.5))
                        }
                    }
                }

                Spacer()

                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(.Text).opacity(0.3))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(sound.isCustomized ? Color(.PrimaryPurple).opacity(0.2) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

class CreateSoundViewModel: ObservableObject {
    @Published var availableSounds: [AvailableSound] = []
    @Published var addedSounds: [AddedSound] = []
    @Published var selectedSound: AddedSound?
    @Published var selectedBackground: BackgroundSound?
    @Published var selectedOriginalSound: AvailableSound?

    // 각 사운드의 커스터마이징 설정을 저장
    @Published var soundVariations: [String: AudioVariation] = [:]

    @Published var backgroundVolume: Float = 0.3 {
        didSet {
            audioManager.backgroundVolume = backgroundVolume
        }
    }

    // 현재 편집 중인 사운드의 variation (computed property)
    var currentVariation: AudioVariation {
        get {
            guard let sound = selectedOriginalSound else {
                return AudioVariation()
            }
            return soundVariations[sound.id] ?? AudioVariation()
        }
        set {
            guard let sound = selectedOriginalSound else { return }
            soundVariations[sound.id] = newValue
            // 변경 시 재생 중인 사운드에 실시간 반영
            playPreview(sound: sound)
        }
    }

    private let audioManager = AudioEngineManager.shared
    private let userDefaults = UserDefaultsManager.shared
    private let fileManager = UserFileManager.shared

    init() {
        loadAvailableSounds()
    }

    deinit {
        print("🗑️ [CreateSoundViewModel] deinit - 화면 해제됨")
        audioManager.stopAll()
    }

    private func loadAvailableSounds() {
        availableSounds = [
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
            )
        ]
    }

    func playPreview(sound: AvailableSound) {
        print("\n▶️ [CreateSoundViewModel] playPreview() 호출됨")
        print("   - 선택된 원본 사운드: \(sound.name)")
        print("   - 현재 배경음: \(selectedBackground?.rawValue ?? "없음")")

        // 동일한 원본 사운드 선택시 토글 (선택 해제)
        if selectedOriginalSound?.id == sound.id {
            print("   ↩️ 동일한 원본 사운드 선택 - 토글하여 제거")
            selectedOriginalSound = nil
            audioManager.stop()
            print("   🛑 원본 사운드 중지 (배경음은 계속 재생)")
            return
        }

        // 선택된 원본 사운드 업데이트
        selectedOriginalSound = sound

        // 기존 메인 사운드만 중지 (배경음은 유지)
        audioManager.stop()

        // 오디오 커스터마이징 파라미터 적용
        let variation = currentVariation
        audioManager.audioVariation = variation
        print("   🎚️ 오디오 파라미터 적용: 볼륨=\(variation.volume), 피치=\(variation.pitch), 간격=\(variation.interval)")

        // 원본 사운드 생성
        let originalSound = OriginalSound(
            name: sound.name,
            filter: sound.filter,
            category: sound.category
        )

        // 배경음과 함께 계속 재생
        audioManager.play(with: originalSound)
        print("   ✅ 원본 사운드 재생 시작 (배경음과 함께 계속 재생)")
        print("   🔁 원본 사운드는 멈추지 않고 계속 반복됩니다")
    }

    func stopPreview() {
        print("🛑 [CreateSoundViewModel] stopPreview() 호출됨")
        audioManager.stopAll()
        print("   - 모든 사운드 중지 (화면 닫힐 때)")
    }

    func selectBackground(_ background: BackgroundSound) {
        print("\n🌊 [CreateSoundViewModel] selectBackground() 호출됨")
        print("   - 선택된 배경음: \(background.rawValue)")
        print("   - 이전 배경음: \(selectedBackground?.rawValue ?? "없음")")

        // 기존 배경음 중지
        audioManager.stopBackground()

        // 동일한 배경음 선택시 토글 (제거)
        if selectedBackground == background {
            print("   ↩️ 동일한 배경음 선택 - 토글하여 제거")
            selectedBackground = nil
            return
        }

        // 새 배경음 선택 및 재생 (계속 재생)
        selectedBackground = background
        audioManager.playBackground(background)
        print("   ✅ 배경음 재생 시작 (계속 재생)")
    }

    func clearBackground() {
        audioManager.stopBackground()
        selectedBackground = nil
    }

    func saveCustomSound(title: String) -> Bool {
        print("\n" + String(repeating: "=", count: 60))
        print("💾 [SAVE] 사운드 저장 시작")
        print(String(repeating: "=", count: 60))

        // 원본 사운드가 선택되어 있어야 함
        guard let originalSound = selectedOriginalSound else {
            print("❌ [SAVE] 실패: 원본 사운드가 선택되지 않았습니다.")
            print(String(repeating: "=", count: 60) + "\n")
            return false
        }

        print("✅ [SAVE] 원본 사운드: \(originalSound.name) (\(originalSound.filter.rawValue))")

        var customSounds = userDefaults.customSounds
        print("📊 [SAVE] 현재 저장된 사운드 개수: \(customSounds.count)")

        // 중복 체크
        if customSounds.contains(where: { $0.title == title }) {
            print("❌ [SAVE] 실패: 이미 이 이름의 사운드가 존재합니다: '\(title)'")
            print(String(repeating: "=", count: 60) + "\n")
            return false
        }

        print("✅ [SAVE] 중복 체크 통과: '\(title)'")

        let variation = currentVariation
        let customSound = CustomSound(
            title: title,
            category: originalSound.category,
            variation: variation,
            filter: originalSound.filter,
            color: originalSound.category.defaultColor,
            backgroundSound: selectedBackground?.rawValue,
            backgroundVolume: selectedBackground != nil ? backgroundVolume : nil
        )

        print("\n📝 [SAVE] 저장할 사운드 정보:")
        print("   🏷️  제목: \(title)")
        print("   🎵 카테고리: \(originalSound.category.displayName)")
        print("   🎚️  필터: \(originalSound.filter.rawValue)")
        print("   🎨 색상: \(customSound.color)")
        print("   🌊 배경음: \(selectedBackground?.rawValue ?? "없음")")
        print("   📊 배경 볼륨: \(backgroundVolume * 100)%")
        print("\n   ⚙️  오디오 설정:")
        print("      볼륨: \(Int(variation.volume * 100))% (변동: ±\(Int(variation.volumeVariation * 100))%)")
        print("      피치: \(String(format: "%.1f", variation.pitch)) (변동: ±\(Int(variation.pitchVariation * 100))%)")
        print("      간격: \(String(format: "%.2f", variation.interval))초 (변동: ±\(Int(variation.intervalVariation * 100))%)")

        print("\n💿 [SAVE] 파일 시스템에 저장 중...")
        if !fileManager.saveCustomSound(customSound) {
            print("❌ [SAVE] 실패: 파일 저장 실패")
            print(String(repeating: "=", count: 60) + "\n")
            return false
        }
        print("✅ [SAVE] 파일 저장 성공")

        print("\n📱 [SAVE] UserDefaults에 저장 중...")
        customSounds.append(customSound)
        userDefaults.customSounds = customSounds
        print("✅ [SAVE] UserDefaults 저장 성공")

        print("\n📊 [SAVE] 저장 후 총 사운드 개수: \(customSounds.count)")
        print("🎉 [SAVE] 사운드 '\(title)' 저장 완료!")
        print(String(repeating: "=", count: 60) + "\n")

        return true
    }
}

struct AvailableSound: Identifiable, Equatable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let category: SoundCategory
    let filter: AudioFilter
    let duration: TimeInterval

    static func == (lhs: AvailableSound, rhs: AvailableSound) -> Bool {
        return lhs.id == rhs.id
    }
}

struct AddedSound: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
    let category: SoundCategory
    let filter: AudioFilter
    var isCustomized: Bool
}

// MARK: - Sound Canvas Visualization

/// 실시간 물방울 시각화 (오디오와 싱크 맞춤)
struct SoundCanvasVisualization: View {
    @ObservedObject var viewModel: CreateSoundViewModel
    @State private var drops: [SoundDrop] = []
    @State private var audioEventCancellable: AnyCancellable?
    private let audioManager = AudioEngineManager.shared

    var body: some View {
        ZStack {
            // 배경 그라데이션
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            (viewModel.selectedOriginalSound?.color ?? .blue).opacity(0.2),
                            (viewModel.selectedOriginalSound?.color ?? .blue).opacity(0.05),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 20,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)

            // 물방울들
            ForEach(drops) { drop in
                SoundDropCircle(drop: drop)
            }

            // 중앙 아이콘만 표시 (텍스트 제거)
            if let original = viewModel.selectedOriginalSound {
                Image(systemName: original.icon)
                    .font(.system(size: 32))
                    .foregroundColor(original.color.opacity(0.3))
            }
        }
        .frame(height: 240)
        .onAppear {
            startVisualization()
        }
        .onDisappear {
            stopVisualization()
        }
    }

    func startVisualization() {
        print("🎨 [SoundCanvas] 시각화 시작 - 오디오 이벤트 구독")

        // AudioEngineManager의 실제 재생 이벤트를 구독
        audioEventCancellable = audioManager.soundDidPlay
            .receive(on: DispatchQueue.main)
            .sink { [self] event in
                print("   🎵 물방울 생성: 볼륨=\(event.volume), 피치=\(event.pitch)")
                self.addDrop(volume: event.volume, pitch: event.pitch)
                self.cleanupOldDrops()
            }
    }

    func stopVisualization() {
        print("🛑 [SoundCanvas] 시각화 중지")
        audioEventCancellable?.cancel()
        audioEventCancellable = nil
        drops.removeAll()
    }

    func addDrop(volume: Float, pitch: Float) {
        // 피치에 따라 X 위치 결정 (-24 ~ +24 범위를 60 ~ 180으로 매핑)
        let normalizedPitch = (CGFloat(pitch) + 24.0) / 48.0 // 0.0 ~ 1.0
        let xPosition = 60 + (normalizedPitch * 120) // 60 ~ 180

        let drop = SoundDrop(
            volume: CGFloat(volume),
            pitch: CGFloat(pitch),
            baseColor: viewModel.selectedOriginalSound?.color ?? .blue,
            position: CGPoint(x: xPosition, y: 120)
        )

        drops.append(drop)
    }

    func cleanupOldDrops() {
        drops.removeAll { $0.createdAt.timeIntervalSinceNow < -2.5 }
    }
}

// MARK: - Sound Drop Model

struct SoundDrop: Identifiable {
    let id = UUID()
    let volume: CGFloat
    let pitch: CGFloat
    let baseColor: Color
    let position: CGPoint
    let createdAt = Date()

    var color: Color {
        // 피치에 따라 색상 변화
        if pitch == 0 {
            return baseColor
        }

        let normalized = (pitch + 24.0) / 48.0 // 0.0 ~ 1.0
        let adjustment = (normalized - 0.5) * 0.15

        return baseColor.opacity(0.8 + adjustment)
    }
}

// MARK: - Sound Drop Circle

struct SoundDropCircle: View {
    let drop: SoundDrop
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0

    var body: some View {
        let baseSize: CGFloat = 30
        let volumeMultiplier = drop.volume * 2.0 // 볼륨에 따라 최대 크기 결정
        let maxScale = 1.0 + volumeMultiplier // 볼륨이 클수록 크게 커짐

        Circle()
            .stroke(drop.color, lineWidth: 2.5 * drop.volume)
            .frame(width: baseSize, height: baseSize)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(drop.position)
            .onAppear {
                withAnimation(.easeOut(duration: 2.0)) {
                    scale = maxScale
                    opacity = 0.0
                }
            }
    }
}

