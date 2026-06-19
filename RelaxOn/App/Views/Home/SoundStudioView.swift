//
//  SoundStudioView.swift
//  RelaxOn
//
//  소리 생성 과정 개편:
//  1) 배경 장소를 고르면 그에 맞는 소리가 바로 재생되고
//  2) 두드리기/끌기로 간격, 불규칙 다이얼, 공간감, 볼륨을 감각적으로 조정한다.
//

import SwiftUI

// MARK: - Place Model

/// 배경 장소 → 소리(카테고리·필터) + 기본 느낌 매핑
struct SoundPlace: Identifiable {
    let id: String
    let nameKey: String
    let icon: String
    let colorHex: String
    let category: SoundCategory
    let filter: AudioFilter
    // 기본 느낌
    let interval: Float
    let pitch: Float
    let volume: Float
    let irregularity: Float   // intervalVariation 등으로 매핑

    static let all: [SoundPlace] = [
        SoundPlace(id: "cave",     nameKey: L.Place.cave,      icon: "mountain.2.fill",     colorHex: "6C6AD1", category: .WaterDrop, filter: .Cave,     interval: 1.6, pitch: -2.5, volume: 0.7, irregularity: 0.30),
        SoundPlace(id: "basement", nameKey: L.Place.basement,  icon: "square.split.bottomrightquarter.fill", colorHex: "5E7CA8", category: .WaterDrop, filter: .Basement, interval: 1.2, pitch: -1.0, volume: 0.7, irregularity: 0.22),
        SoundPlace(id: "sink",     nameKey: L.Place.sink,      icon: "drop.fill",           colorHex: "4FA8C8", category: .WaterDrop, filter: .Sink,    interval: 0.8, pitch:  0.0, volume: 0.6, irregularity: 0.12),
        SoundPlace(id: "forest",   nameKey: L.Place.forest,    icon: "tree.fill",           colorHex: "5BAE7C", category: .Bird,     filter: .Forest,  interval: 1.0, pitch:  0.0, volume: 0.6, irregularity: 0.40),
        SoundPlace(id: "jungle",   nameKey: L.Place.jungle,    icon: "leaf.fill",           colorHex: "3E9E6A", category: .Bird,     filter: .Jungle,  interval: 0.9, pitch:  0.0, volume: 0.6, irregularity: 0.45),
        SoundPlace(id: "rain",     nameKey: L.Place.rain,      icon: "cloud.rain.fill",     colorHex: "6F8FC2", category: .Rain,     filter: .SoftRain,interval: 0.5, pitch: -0.5, volume: 0.7, irregularity: 0.30),
        SoundPlace(id: "cityrain", nameKey: L.Place.cityRain,  icon: "building.2.fill",     colorHex: "7B86A0", category: .Rain,     filter: .CityRain,interval: 0.6, pitch: -0.5, volume: 0.7, irregularity: 0.35),
        SoundPlace(id: "temple",   nameKey: L.Place.temple,    icon: "moon.stars.fill",     colorHex: "9A7BD0", category: .SingingBowl, filter: .TibetanBowl, interval: 2.0, pitch: -1.0, volume: 0.6, irregularity: 0.15)
    ]
}

// MARK: - Studio View

struct SoundStudioView: View {
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @Environment(\.dismiss) var dismiss

    @State private var selectedPlace: SoundPlace? = nil
    @State private var showSave = false

    // 두드리기(탭) 리듬 측정
    @State private var lastTapTime: Date? = nil
    @State private var tapGaps: [Double] = []
    // 끌기 시작 시점의 간격
    @State private var dragBaseInterval: Float? = nil

    var body: some View {
        ZStack {
            ScreenBackground()

            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: DS.Spacing.lg) {
                        // STEP 1 — 장소
                        placeSection()

                        if selectedPlace != nil {
                            // STEP 2 — 세부 조정 (장소 선택 시 이 영역으로 포커스 이동)
                            VStack(spacing: DS.Spacing.lg) {
                                // 실시간 시각화
                                if viewModel.isPlaying {
                                    WaterDropVisualization(viewModel: viewModel)
                                        .frame(height: 120)
                                        .accessibilityHidden(true)
                                }

                                SectionHeader(title: L.Studio.fineTune.localized, systemIcon: "slider.horizontal.3")
                                    .padding(.horizontal, DS.Spacing.screen)

                                rhythmPad()
                                irregularityControl()
                                spaceControl()
                                volumeControl()
                            }
                            .id("fineTune")
                        }
                    }
                    .padding(.vertical, DS.Spacing.md)
                    .dsConstrainedWidth()
                }
                .onChange(of: selectedPlace?.id) { newId in
                    guard newId != nil else { return }
                    // 레이아웃이 잡힌 뒤 세부 조정으로 부드럽게 스크롤
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        withAnimation(.easeInOut(duration: 0.45)) {
                            proxy.scrollTo("fineTune", anchor: .top)
                        }
                    }
                }
            }
        }
        .navigationTitle(L.Studio.title.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if selectedPlace != nil {
                    Button { showSave = true } label: {
                        Text(L.Common.next.localized)
                            .font(DS.Font.subhead().weight(.semibold))
                            .foregroundColor(DS.Colors.accent)
                    }
                }
            }
        }
        .navigationDestination(isPresented: $showSave) {
            if let place = selectedPlace {
                SoundSaveView(originalSound: OriginalSound(name: place.nameKey.localized,
                                                           filter: place.filter,
                                                           category: place.category))
                    .environmentObject(viewModel)
            }
        }
        .onDisappear { viewModel.stopSound() }
    }

    // MARK: STEP 1 — Places

    @ViewBuilder
    private func placeSection() -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            SectionHeader(title: L.Studio.whereHeard.localized, systemIcon: "mappin.and.ellipse")
                .padding(.horizontal, DS.Spacing.screen)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: DS.Spacing.sm),
                                GridItem(.flexible(), spacing: DS.Spacing.sm)],
                      spacing: DS.Spacing.sm) {
                ForEach(SoundPlace.all) { place in
                    placeTile(place)
                }
            }
            .padding(.horizontal, DS.Spacing.screen)
        }
    }

    @ViewBuilder
    private func placeTile(_ place: SoundPlace) -> some View {
        let selected = selectedPlace?.id == place.id
        Button { selectPlace(place) } label: {
            HStack(spacing: DS.Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(Color(hex: place.colorHex).opacity(selected ? 1.0 : 0.85))
                        .frame(width: 40, height: 40)
                    Image(systemName: place.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                Text(place.nameKey.localized)
                    .font(DS.Font.headline())
                    .foregroundColor(selected ? DS.Colors.onAccent : DS.Colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 0)
            }
            .padding(DS.Spacing.sm)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous)
                    .fill(selected ? DS.Colors.accent : DS.Colors.surface)
            )
            .shadow(color: DS.Shadow.card.color, radius: DS.Shadow.card.radius, y: DS.Shadow.card.y)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(place.nameKey.localized)
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }

    private func selectPlace(_ place: SoundPlace) {
        selectedPlace = place
        // 탭 리듬 초기화
        lastTapTime = nil
        tapGaps = []

        let sound = OriginalSound(name: place.nameKey.localized, filter: place.filter, category: place.category)
        viewModel.sound = sound
        viewModel.interval = place.interval
        viewModel.pitch = place.pitch
        viewModel.volume = place.volume
        viewModel.intervalVariation = place.irregularity
        viewModel.volumeVariation = place.irregularity * 0.5
        viewModel.pitchVariation = place.irregularity * 0.4
        viewModel.filter = place.filter   // 동일 사운드 재생 트리거
        viewModel.play(with: sound)
    }

    // MARK: STEP 2 — #1 두드리기 + #3 끌기 (간격)

    @ViewBuilder
    private func rhythmPad() -> some View {
        controlCard {
            HStack {
                Image(systemName: "hand.tap.fill")
                    .foregroundColor(DS.Colors.accent)
                    .accessibilityHidden(true)
                Text(L.Studio.interval.localized)
                    .font(DS.Font.headline())
                    .foregroundColor(DS.Colors.textPrimary)
                Spacer()
                Text(String(format: "%.1f%@", viewModel.interval, L.Customize.seconds.localized))
                    .font(DS.Font.headline())
                    .foregroundColor(DS.Colors.accent)
            }

            ZStack {
                RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous)
                    .fill(DS.Colors.surfaceSunken)
                Text(L.Studio.intervalHint.localized)
                    .font(DS.Font.subhead())
                    .foregroundColor(DS.Colors.textTertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, DS.Spacing.md)
            }
            .frame(height: 96)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if abs(value.translation.width) > 6 {
                            // 끌기(#3): 오른쪽=길게, 왼쪽=짧게
                            if dragBaseInterval == nil { dragBaseInterval = viewModel.interval }
                            let base = dragBaseInterval ?? viewModel.interval
                            let delta = Float(value.translation.width) / 160.0 // 160pt ≈ 1초
                            viewModel.interval = min(2.0, max(0.1, base + delta))
                        }
                    }
                    .onEnded { value in
                        if abs(value.translation.width) <= 6 {
                            registerTap() // 두드리기(#1)
                        }
                        dragBaseInterval = nil
                    }
            )
            .accessibilityLabel(L.Studio.interval.localized)
            .accessibilityValue(String(format: "%.1f%@", viewModel.interval, L.Customize.seconds.localized))
        }
    }

    /// 두드린 간격을 평균내어 interval로 반영
    private func registerTap() {
        let now = Date()
        if let last = lastTapTime {
            let gap = now.timeIntervalSince(last)
            if gap > 2.5 {
                // 너무 오래 쉬면 새 리듬으로 리셋
                tapGaps = []
            } else {
                tapGaps.append(gap)
                if tapGaps.count > 4 { tapGaps.removeFirst() }
                let avg = tapGaps.reduce(0, +) / Double(tapGaps.count)
                viewModel.interval = min(2.0, max(0.1, Float(avg)))
            }
        }
        lastTapTime = now
    }

    // MARK: STEP 2 — #6 불규칙함 다이얼

    @ViewBuilder
    private func irregularityControl() -> some View {
        controlCard {
            HStack {
                Image(systemName: "waveform.path.ecg")
                    .foregroundColor(DS.Colors.accent)
                    .accessibilityHidden(true)
                Text(L.Studio.irregularity.localized)
                    .font(DS.Font.headline())
                    .foregroundColor(DS.Colors.textPrimary)
                Spacer()
            }

            Slider(value: Binding(
                get: { viewModel.intervalVariation },
                set: { v in
                    viewModel.intervalVariation = v
                    viewModel.volumeVariation = v * 0.5
                    viewModel.pitchVariation = v * 0.4
                }
            ), in: 0.0...0.5, step: 0.01)
            .tint(DS.Colors.accent)
            .accessibilityLabel(L.Studio.irregularity.localized)

            HStack {
                Text(L.Studio.regular.localized)
                Spacer()
                Text(L.Studio.natural.localized)
            }
            .font(DS.Font.caption())
            .foregroundColor(DS.Colors.textTertiary)
            .accessibilityHidden(true)
        }
    }

    // MARK: STEP 2 — #5 공간감

    @ViewBuilder
    private func spaceControl() -> some View {
        controlCard {
            HStack {
                Image(systemName: "rectangle.expand.vertical")
                    .foregroundColor(DS.Colors.accent)
                    .accessibilityHidden(true)
                Text(L.Studio.space.localized)
                    .font(DS.Font.headline())
                    .foregroundColor(DS.Colors.textPrimary)
                Spacer()
            }

            // 좁음(+2, 높은 톤) ↔ 넓음(-4, 깊은 톤) → pitch에 매핑 (역방향)
            Slider(value: Binding(
                get: { (2.0 - viewModel.pitch) / 6.0 }, // pitch +2..-4 → 0..1
                set: { v in viewModel.pitch = 2.0 - v * 6.0 }
            ), in: 0.0...1.0)
            .tint(DS.Colors.accent)
            .accessibilityLabel(L.Studio.space.localized)

            HStack {
                Text(L.Studio.narrow.localized)
                Spacer()
                Text(L.Studio.wide.localized)
            }
            .font(DS.Font.caption())
            .foregroundColor(DS.Colors.textTertiary)
            .accessibilityHidden(true)
        }
    }

    // MARK: STEP 2 — 볼륨

    @ViewBuilder
    private func volumeControl() -> some View {
        controlCard {
            HStack {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(DS.Colors.accent)
                    .accessibilityHidden(true)
                Text(L.Customize.volume.localized)
                    .font(DS.Font.headline())
                    .foregroundColor(DS.Colors.textPrimary)
                Spacer()
                Text(String(format: "%.0f%%", viewModel.volume * 100))
                    .font(DS.Font.headline())
                    .foregroundColor(DS.Colors.accent)
            }
            Slider(value: $viewModel.volume, in: 0.1...1.0, step: 0.01)
                .tint(DS.Colors.accent)
                .accessibilityLabel(L.Customize.volume.localized)
                .accessibilityValue(String(format: "%.0f%%", viewModel.volume * 100))
        }
    }

    // MARK: - Helper

    @ViewBuilder
    private func controlCard<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            content()
        }
        .padding(DS.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous)
                .fill(DS.Colors.surface)
        )
        .shadow(color: DS.Shadow.card.color, radius: DS.Shadow.card.radius, y: DS.Shadow.card.y)
        .padding(.horizontal, DS.Spacing.screen)
    }
}
