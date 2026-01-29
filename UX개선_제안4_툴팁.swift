// UX 개선안 4: 인터랙티브 설명과 예시

import SwiftUI

// MARK: - 도움말 툴팁

struct HelpTooltip: View {
    let title: String
    let explanation: String
    let examples: [String]
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.PrimaryPurple))

                    Text(title)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(.Text).opacity(0.8))

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 10))
                        .foregroundColor(Color(.Text).opacity(0.5))
                }
            }

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // 설명
                    Text(explanation)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.Text).opacity(0.7))
                        .fixedSize(horizontal: false, vertical: true)

                    // 예시
                    if !examples.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("예시:")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(.Text).opacity(0.6))

                            ForEach(examples, id: \.self) { example in
                                HStack(alignment: .top, spacing: 6) {
                                    Text("•")
                                        .foregroundColor(Color(.PrimaryPurple))
                                    Text(example)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(.Text).opacity(0.7))
                                }
                            }
                        }
                        .padding(.leading, 8)
                    }
                }
                .padding(12)
                .background(Color(.PrimaryPurple).opacity(0.05))
                .cornerRadius(8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(10)
        .background(Color(.CircularSliderBackground).opacity(0.2))
        .cornerRadius(8)
    }
}

// MARK: - 변동폭 설명 컴포넌트

struct VariationExplainer: View {
    let parameterName: String
    let baseValue: Float
    let variation: Float
    let unit: String

    var body: some View {
        HelpTooltip(
            title: "\(parameterName) 변화에 대해 알아보기",
            explanation: explanationText,
            examples: exampleTexts
        )
    }

    var explanationText: String {
        if variation == 0 {
            return "\(parameterName)이(가) 항상 \(formatValue(baseValue))\(unit)로 일정하게 유지됩니다. 메트로놈처럼 정확한 리듬을 원할 때 적합합니다."
        } else {
            let min = baseValue * (1.0 - variation)
            let max = baseValue * (1.0 + variation)
            return "매번 재생될 때마다 \(formatValue(min))\(unit)에서 \(formatValue(max))\(unit) 사이에서 랜덤하게 변합니다."
        }
    }

    var exampleTexts: [String] {
        if variation == 0 {
            return [
                "집중력이 필요한 작업",
                "명상이나 호흡 운동",
                "규칙적인 리듬이 필요할 때"
            ]
        } else if variation <= 0.2 {
            return [
                "자연스러우면서도 예측 가능",
                "부드러운 배경 소음",
                "수면이나 독서에 적합"
            ]
        } else if variation <= 0.4 {
            return [
                "실제 자연의 소리와 유사",
                "빗소리나 계곡물처럼 다채로움",
                "장시간 들어도 지루하지 않음"
            ]
        } else {
            return [
                "매우 역동적이고 다양함",
                "완전히 예측 불가능한 패턴",
                "창의적 작업이나 브레인스토밍에 적합"
            ]
        }
    }

    func formatValue(_ value: Float) -> String {
        return String(format: "%.1f", value)
    }
}

// MARK: - 실시간 값 미리보기

struct LiveValuePreview: View {
    @ObservedObject var viewModel: CustomSoundViewModel
    @State private var previewValues: [PreviewValue] = []
    @State private var timer: Timer?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "eye.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.PrimaryPurple))

                Text("실제로 이렇게 들립니다")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(.TitleText))

                Spacer()

                Button(action: {
                    generatePreview()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 12))
                        Text("다시보기")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(Color(.PrimaryPurple))
                }
            }

            if !previewValues.isEmpty {
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach(previewValues) { preview in
                            previewRow(preview: preview)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding(12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.PrimaryPurple).opacity(0.05),
                    Color(.PrimaryPurple).opacity(0.02)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .onAppear {
            generatePreview()
        }
    }

    @ViewBuilder
    func previewRow(preview: PreviewValue) -> some View {
        HStack(spacing: 8) {
            // 인덱스
            Text("\(preview.index)")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(.Text).opacity(0.4))
                .frame(width: 20)

            // 간격 (시각적 바)
            HStack(spacing: 2) {
                ForEach(0..<Int(preview.interval * 10), id: \.self) { _ in
                    Rectangle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: 3, height: 6)
                }
            }
            .frame(width: 60, alignment: .leading)

            Text(String(format: "%.1f초", preview.interval))
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 40, alignment: .trailing)

            // 볼륨 (원 크기)
            Circle()
                .fill(Color.green.opacity(0.6))
                .frame(width: CGFloat(preview.volume * 20), height: CGFloat(preview.volume * 20))
                .frame(width: 20)

            Text(String(format: "%.0f%%", preview.volume * 100))
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.green)
                .frame(width: 35, alignment: .trailing)

            // 피치 (화살표)
            Image(systemName: preview.pitch > 0 ? "arrow.up" : preview.pitch < 0 ? "arrow.down" : "minus")
                .font(.system(size: 10))
                .foregroundColor(.orange)

            Text(String(format: "%+.1f", preview.pitch))
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.orange)
                .frame(width: 35, alignment: .trailing)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color(.CircularSliderBackground).opacity(0.3))
        .cornerRadius(6)
    }

    func generatePreview() {
        previewValues = (1...10).map { index in
            PreviewValue(
                index: index,
                interval: randomizedValue(
                    base: viewModel.interval,
                    variation: viewModel.intervalVariation
                ),
                volume: randomizedValue(
                    base: viewModel.volume,
                    variation: viewModel.volumeVariation
                ),
                pitch: randomizedPitch(
                    base: viewModel.pitch,
                    variation: viewModel.pitchVariation
                )
            )
        }
    }

    func randomizedValue(base: Float, variation: Float) -> Float {
        let randomFactor = Float.random(in: -variation...variation)
        return max(0.1, base * (1.0 + randomFactor))
    }

    func randomizedPitch(base: Float, variation: Float) -> Float {
        let randomFactor = Float.random(in: -variation...variation)
        return base + (randomFactor * 24.0)
    }
}

struct PreviewValue: Identifiable {
    let id = UUID()
    let index: Int
    let interval: Float
    let volume: Float
    let pitch: Float
}

// MARK: - 비교 모드 (Before/After)

struct ComparisonToggle: View {
    @Binding var showVariation: Bool

    var body: some View {
        HStack(spacing: 16) {
            Text("변화 비교")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.TitleText))

            Spacer()

            HStack(spacing: 12) {
                comparisonButton(title: "규칙적", isSelected: !showVariation) {
                    showVariation = false
                }

                comparisonButton(title: "자연스러움", isSelected: showVariation) {
                    showVariation = true
                }
            }
        }
        .padding(12)
        .background(Color(.CircularSliderBackground).opacity(0.2))
        .cornerRadius(10)
    }

    @ViewBuilder
    func comparisonButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isSelected ? .white : Color(.Text))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected
                        ? Color(.PrimaryPurple)
                        : Color(.CircularSliderBackground).opacity(0.5)
                )
                .cornerRadius(8)
        }
    }
}
