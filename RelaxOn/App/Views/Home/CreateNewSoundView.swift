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

    var body: some View {
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        // 상단 추가된 레이어 프리뷰
                        if !viewModel.addedSounds.isEmpty {
                            layerPreviewSection()
                        } else {
                            emptyLayerSection()
                        }

                        // 메인 컨텐츠 영역
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
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
                .frame(maxWidth: .infinity)
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

        // 여러 사운드 레이어 생성
        let layers = viewModel.addedSounds.map { sound in
            CustomSound.SoundLayer(
                category: sound.category,
                filter: sound.filter,
                audioVariation: AudioVariation(
                    volume: 1.0,
                    pitch: 0.0,
                    interval: 1.5,
                    intervalVariation: 0.2,
                    volumeVariation: 0.1,
                    pitchVariation: 0.0
                )
            )
        }

        // CustomSound 생성
        let newSound = CustomSound(
            title: title,
            category: mainSound.category,
            variation: AudioVariation(
                volume: 1.0,
                pitch: 0.0,
                interval: 1.5,
                intervalVariation: 0.2,
                volumeVariation: 0.1,
                pitchVariation: 0.0
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


    // MARK: - Layer Preview Section (상단 미리보기)
    @ViewBuilder
    private func layerPreviewSection() -> some View {
        VStack(spacing: 0) {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.PrimaryPurple).opacity(0.15),
                    Color(.PrimaryPurple).opacity(0.08)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(
                VStack(spacing: 16) {
                    // 타이틀
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(.PrimaryPurple))

                        Text(L.CreateSound.selectedLayers.localized)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(.TitleText))

                        Text("\(viewModel.addedSounds.count)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(.PrimaryPurple))
                            .cornerRadius(12)

                        Spacer()
                    }

                    // 레이어 칩들
                    FlowLayout(spacing: 8) {
                        ForEach(viewModel.addedSounds) { sound in
                            HStack(spacing: 6) {
                                Image(systemName: sound.icon)
                                    .font(.system(size: 12))
                                    .foregroundColor(sound.color)

                                Text(sound.name)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(.TitleText))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: sound.color.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(20)
            )
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Empty Layer Section
    @ViewBuilder
    private func emptyLayerSection() -> some View {
        VStack(spacing: 12) {
            Image(systemName: "waveform.circle")
                .font(.system(size: 48))
                .foregroundColor(Color(.PrimaryPurple).opacity(0.3))

            Text(L.CreateSound.selectOriginalSound.localized)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(.Text).opacity(0.6))

            Text(L.CreateSound.combineMultipleSounds.localized)
                .font(.system(size: 13))
                .foregroundColor(Color(.Text).opacity(0.4))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.PrimaryPurple).opacity(0.05),
                    Color(.PrimaryPurple).opacity(0.02)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Original Sounds Section
    @ViewBuilder
    private func originalSoundsSection() -> some View {
        VStack(spacing: 16) {
            // 헤더
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L.CreateSound.originalSounds.localized)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(.TitleText))

                    HStack(spacing: 6) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 12))
                        Text(L.CreateSound.tapToSelectMultiple.localized)
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(.Text).opacity(0.5))
                }

                Spacer()
            }

            // 사운드 그리드
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
                        isSelected: viewModel.isSoundAdded(sound)
                    ) {
                        viewModel.toggleSound(sound)
                    }
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
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

// MARK: - Preview

struct CreateNewSoundView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateNewSoundView()
        }
    }
}
