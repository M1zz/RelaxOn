// UX 개선안 2: 빠른 프리셋 선택 버튼

// MARK: - 변동 프리셋

struct VariationPreset: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let description: String
    let intervalVariation: Float
    let volumeVariation: Float
    let pitchVariation: Float

    static let presets: [VariationPreset] = [
        VariationPreset(
            name: "규칙적",
            emoji: "📏",
            description: "메트로놈처럼 정확한 리듬",
            intervalVariation: 0.0,
            volumeVariation: 0.0,
            pitchVariation: 0.0
        ),
        VariationPreset(
            name: "부드러움",
            emoji: "🌊",
            description: "약간의 자연스러운 변화",
            intervalVariation: 0.15,
            volumeVariation: 0.15,
            pitchVariation: 0.10
        ),
        VariationPreset(
            name: "자연스러움",
            emoji: "🌿",
            description: "실제 자연의 소리처럼",
            intervalVariation: 0.30,
            volumeVariation: 0.30,
            pitchVariation: 0.25
        ),
        VariationPreset(
            name: "역동적",
            emoji: "⚡",
            description: "풍부하고 다채로운 변화",
            intervalVariation: 0.45,
            volumeVariation: 0.40,
            pitchVariation: 0.40
        ),
        VariationPreset(
            name: "완전 랜덤",
            emoji: "🎲",
            description: "매번 완전히 다른 소리",
            intervalVariation: 0.50,
            volumeVariation: 0.50,
            pitchVariation: 0.50
        ),
        VariationPreset(
            name: "커스텀",
            emoji: "🎨",
            description: "직접 조절하기",
            intervalVariation: 0.0,
            volumeVariation: 0.0,
            pitchVariation: 0.0
        )
    ]
}

// MARK: - 프리셋 선택 UI

@ViewBuilder
func variationPresetSelector(
    selectedPreset: Binding<VariationPreset?>,
    onSelect: @escaping (VariationPreset) -> Void
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        HStack {
            Image(systemName: "sparkles")
                .foregroundColor(Color(.PrimaryPurple))
                .font(.system(size: 16))

            Text("변화 스타일")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.TitleText))

            Spacer()

            if selectedPreset.wrappedValue?.name != "커스텀" {
                Text("빠른 선택")
                    .font(.system(size: 11))
                    .foregroundColor(Color(.Text).opacity(0.6))
            }
        }
        .padding(.horizontal, 4)

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(VariationPreset.presets) { preset in
                    presetButton(preset: preset, isSelected: selectedPreset.wrappedValue?.name == preset.name) {
                        selectedPreset.wrappedValue = preset
                        if preset.name != "커스텀" {
                            onSelect(preset)
                        }
                    }
                }
            }
        }
    }
    .padding(12)
    .background(Color(.CircularSliderBackground).opacity(0.2))
    .cornerRadius(12)
}

@ViewBuilder
func presetButton(preset: VariationPreset, isSelected: Bool, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        VStack(spacing: 6) {
            // 이모지 + 체크마크
            ZStack(alignment: .topTrailing) {
                Text(preset.emoji)
                    .font(.system(size: 32))

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.green)
                        .background(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 14, height: 14)
                        )
                }
            }
            .frame(height: 44)

            // 이름
            Text(preset.name)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? Color(.PrimaryPurple) : Color(.Text))

            // 설명
            Text(preset.description)
                .font(.system(size: 10))
                .foregroundColor(Color(.Text).opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(width: 100)
        .padding(12)
        .background(
            isSelected
                ? Color(.PrimaryPurple).opacity(0.15)
                : Color(.CircularSliderBackground).opacity(0.5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isSelected ? Color(.PrimaryPurple) : Color.clear,
                    lineWidth: 2
                )
        )
        .cornerRadius(12)
    }
}

// MARK: - 사용 예시

struct ImprovedSoundDetailView: View {
    @State private var selectedPreset: VariationPreset? = VariationPreset.presets[2] // 기본값: 자연스러움
    @State private var showCustomSliders = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 기본 파라미터 (볼륨, 간격, 피치)
                // ...

                // 프리셋 선택기
                variationPresetSelector(selectedPreset: $selectedPreset) { preset in
                    applyPreset(preset)
                    if preset.name == "커스텀" {
                        withAnimation {
                            showCustomSliders = true
                        }
                    } else {
                        withAnimation {
                            showCustomSliders = false
                        }
                    }
                }

                // 커스텀 모드일 때만 상세 슬라이더 표시
                if showCustomSliders || selectedPreset?.name == "커스텀" {
                    VStack(spacing: 12) {
                        Text("상세 조절")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(.Text).opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // 개별 슬라이더들
                        // improvedVariationSlider(...)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal, 24)
        }
    }

    func applyPreset(_ preset: VariationPreset) {
        // ViewModel에 값 적용
        // viewModel.intervalVariation = preset.intervalVariation
        // viewModel.volumeVariation = preset.volumeVariation
        // viewModel.pitchVariation = preset.pitchVariation
    }
}
