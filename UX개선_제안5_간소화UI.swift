// UX 개선안 5: 초보자용 / 고급 사용자용 모드 분리

import SwiftUI

// MARK: - 간소화된 모드 전환

struct SimplifiedSoundDetailView: View {
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @State private var editMode: EditMode = .simple

    enum EditMode {
        case simple   // 초보자용: 프리셋 선택만
        case advanced // 고급: 모든 파라미터 조절
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 모드 선택 토글
                modeSelector()

                // 사운드 이미지
                soundImageView()

                // 모드별 다른 UI
                if editMode == .simple {
                    simpleMode()
                } else {
                    advancedMode()
                }
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - 모드 선택기

    @ViewBuilder
    func modeSelector() -> some View {
        HStack(spacing: 0) {
            modeButton(
                title: "간편 모드",
                icon: "sparkles",
                mode: .simple,
                description: "추천 스타일 선택"
            )

            modeButton(
                title: "상세 조절",
                icon: "slider.horizontal.3",
                mode: .advanced,
                description: "모든 값 직접 설정"
            )
        }
        .background(Color(.CircularSliderBackground).opacity(0.3))
        .cornerRadius(12)
    }

    @ViewBuilder
    func modeButton(title: String, icon: String, mode: EditMode, description: String) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                editMode = mode
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(editMode == mode ? .white : Color(.Text).opacity(0.6))

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(editMode == mode ? .white : Color(.Text))

                Text(description)
                    .font(.system(size: 10))
                    .foregroundColor(
                        editMode == mode
                            ? Color.white.opacity(0.8)
                            : Color(.Text).opacity(0.5)
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                editMode == mode
                    ? Color(.PrimaryPurple)
                    : Color.clear
            )
            .cornerRadius(10)
        }
    }

    // MARK: - 간편 모드 (프리셋 + 3가지 기본 파라미터만)

    @ViewBuilder
    func simpleMode() -> some View {
        VStack(spacing: 20) {
            // 스타일 선택 (프리셋)
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader(icon: "star.fill", title: "소리 스타일", subtitle: "원하는 느낌을 선택하세요")

                VariationPresetGrid()
            }

            Divider()

            // 기본 3가지만
            VStack(spacing: 16) {
                sectionHeader(icon: "slider.horizontal.3", title: "기본 조절", subtitle: "원하는 만큼만 조정하세요")

                // 볼륨만
                simpleSlider(
                    icon: "speaker.wave.2.fill",
                    label: "크기",
                    value: $viewModel.volume,
                    range: 0.1...1.0,
                    color: .green,
                    formatter: { String(format: "%.0f%%", $0 * 100) }
                )

                // 간격만
                simpleSlider(
                    icon: "timer",
                    label: "속도",
                    value: $viewModel.interval,
                    range: 0.1...2.0,
                    color: .blue,
                    formatter: { String(format: "%.1f초", $0) }
                )

                // 필터만
                filterSelector()
            }

            // 도움말
            helpCard()
        }
    }

    // MARK: - 고급 모드 (모든 파라미터)

    @ViewBuilder
    func advancedMode() -> some View {
        VStack(spacing: 20) {
            // 모든 슬라이더 표시
            VStack(spacing: 16) {
                detailedSlider(
                    icon: "speaker.wave.2.fill",
                    label: "볼륨",
                    value: $viewModel.volume,
                    variation: $viewModel.volumeVariation,
                    range: 0.1...1.0,
                    color: .green,
                    unit: ""
                )

                detailedSlider(
                    icon: "timer",
                    label: "간격",
                    value: $viewModel.interval,
                    variation: $viewModel.intervalVariation,
                    range: 0.1...2.0,
                    color: .blue,
                    unit: "초"
                )

                detailedSlider(
                    icon: "tuningfork",
                    label: "피치",
                    value: $viewModel.pitch,
                    variation: $viewModel.pitchVariation,
                    range: -5.0...5.0,
                    color: .orange,
                    unit: ""
                )

                filterSelector()
            }

            // 실시간 미리보기
            LiveValuePreview(viewModel: viewModel)
        }
    }

    // MARK: - 섹션 헤더

    @ViewBuilder
    func sectionHeader(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color(.PrimaryPurple))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.TitleText))

                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color(.Text).opacity(0.6))
            }

            Spacer()
        }
    }

    // MARK: - 간단한 슬라이더 (변동폭 없음)

    @ViewBuilder
    func simpleSlider(
        icon: String,
        label: String,
        value: Binding<Float>,
        range: ClosedRange<Float>,
        color: Color,
        formatter: @escaping (Float) -> String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)

                Text(label)
                    .font(.system(size: 15, weight: .semibold))

                Spacer()

                Text(formatter(value.wrappedValue))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
            }

            Slider(value: value, in: range, step: 0.1)
                .tint(color)
        }
        .padding(12)
        .background(Color(.CircularSliderBackground).opacity(0.3))
        .cornerRadius(10)
    }

    // MARK: - 상세 슬라이더 (변동폭 포함)

    @ViewBuilder
    func detailedSlider(
        icon: String,
        label: String,
        value: Binding<Float>,
        variation: Binding<Float>,
        range: ClosedRange<Float>,
        color: Color,
        unit: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 기본값
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)

                Text(label)
                    .font(.system(size: 15, weight: .semibold))

                Spacer()

                Text(formatValue(value.wrappedValue, unit: unit))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
            }

            Slider(value: value, in: range, step: 0.1)
                .tint(color)

            // 변동폭 (접고 펼치기)
            DisclosureGroup {
                VStack(spacing: 10) {
                    HStack {
                        Text("변화 범위")
                            .font(.system(size: 13))

                        Spacer()

                        Text(String(format: "±%.0f%%", variation.wrappedValue * 100))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(color)
                    }

                    Slider(value: variation, in: 0.0...0.5, step: 0.05)
                        .tint(color.opacity(0.6))

                    // 예상 범위 표시
                    if variation.wrappedValue > 0 {
                        HStack {
                            Text("예상 범위:")
                                .font(.system(size: 11))
                                .foregroundColor(Color(.Text).opacity(0.6))

                            Spacer()

                            Text("\(formatValue(value.wrappedValue * (1 - variation.wrappedValue), unit: unit)) ~ \(formatValue(value.wrappedValue * (1 + variation.wrappedValue), unit: unit))")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(color.opacity(0.8))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(color.opacity(0.1))
                        .cornerRadius(6)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "waveform.path")
                        .font(.system(size: 12))
                    Text("자연스러움 조절")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(Color(.PrimaryPurple))
            }
        }
        .padding(12)
        .background(Color(.CircularSliderBackground).opacity(0.3))
        .cornerRadius(10)
    }

    func formatValue(_ value: Float, unit: String) -> String {
        if unit == "초" {
            return String(format: "%.1f%@", value, unit)
        } else {
            return String(format: "%.1f", value)
        }
    }

    // MARK: - 기타 컴포넌트

    @ViewBuilder
    func soundImageView() -> some View {
        // 기존 이미지 뷰
        EmptyView()
    }

    @ViewBuilder
    func filterSelector() -> some View {
        // 기존 필터 선택기
        EmptyView()
    }

    @ViewBuilder
    func helpCard() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 20))
                .foregroundColor(.yellow)

            VStack(alignment: .leading, spacing: 4) {
                Text("더 세밀하게 조절하고 싶나요?")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(.TitleText))

                Text("상세 조절 모드로 전환하면 모든 파라미터를 자유롭게 설정할 수 있습니다.")
                    .font(.system(size: 11))
                    .foregroundColor(Color(.Text).opacity(0.7))
            }
        }
        .padding(12)
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - 프리셋 그리드 (간편 모드용)

struct VariationPresetGrid: View {
    @EnvironmentObject var viewModel: CustomSoundViewModel

    let presets = [
        ("📏", "규칙적", "메트로놈", 0.0, 0.0, 0.0),
        ("🌊", "부드러움", "은은한 변화", 0.15, 0.15, 0.10),
        ("🌿", "자연", "실제 자연처럼", 0.30, 0.30, 0.25),
        ("⚡", "역동적", "다채로운", 0.45, 0.40, 0.40)
    ]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(presets, id: \.1) { preset in
                presetCard(
                    emoji: preset.0,
                    name: preset.1,
                    description: preset.2,
                    intervalVar: preset.3,
                    volumeVar: preset.4,
                    pitchVar: preset.5
                )
            }
        }
    }

    @ViewBuilder
    func presetCard(
        emoji: String,
        name: String,
        description: String,
        intervalVar: Float,
        volumeVar: Float,
        pitchVar: Float
    ) -> some View {
        Button(action: {
            applyPreset(intervalVar: intervalVar, volumeVar: volumeVar, pitchVar: pitchVar)
        }) {
            VStack(spacing: 8) {
                Text(emoji)
                    .font(.system(size: 36))

                Text(name)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(.TitleText))

                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(Color(.Text).opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(.CircularSliderBackground).opacity(0.5))
            .cornerRadius(12)
        }
    }

    func applyPreset(intervalVar: Float, volumeVar: Float, pitchVar: Float) {
        withAnimation {
            viewModel.intervalVariation = intervalVar
            viewModel.volumeVariation = volumeVar
            viewModel.pitchVariation = pitchVar
        }
    }
}
