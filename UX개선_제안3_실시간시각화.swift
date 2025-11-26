// UX 개선안 3: 실시간 시각적 피드백

import SwiftUI
import Combine

// MARK: - 물방울 애니메이션 뷰

struct WaterDropVisualization: View {
    @ObservedObject var viewModel: CustomSoundViewModel
    @State private var drops: [WaterDrop] = []
    @State private var cancellable: AnyCancellable?

    var body: some View {
        ZStack {
            // 물결 배경
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.3),
                            Color.blue.opacity(0.05)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 100
                    )
                )
                .frame(width: 200, height: 200)

            // 물방울 표시
            ForEach(drops) { drop in
                WaterDropCircle(drop: drop)
            }

            // 중앙 인디케이터
            VStack(spacing: 8) {
                Text("듣고 있는 소리")
                    .font(.system(size: 12))
                    .foregroundColor(Color(.Text).opacity(0.6))

                HStack(spacing: 4) {
                    Image(systemName: "waveform")
                        .font(.system(size: 14))

                    Text(String(format: "%.1f초", viewModel.interval))
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(Color(.PrimaryPurple))
            }
        }
        .frame(height: 220)
        .onAppear {
            startVisualization()
        }
        .onDisappear {
            cancellable?.cancel()
        }
    }

    func startVisualization() {
        // 실제 재생 간격에 맞춰 시각화
        cancellable = Timer.publish(
            every: 0.1, // 빠른 업데이트로 부드러운 애니메이션
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { _ in
            // 변동폭을 고려한 랜덤 시각화
            if shouldShowDrop() {
                addDrop()
            }
            cleanupOldDrops()
        }
    }

    func shouldShowDrop() -> Bool {
        // 간격과 변동폭을 고려한 확률 계산
        let baseInterval = viewModel.interval
        let variation = viewModel.intervalVariation
        let randomInterval = baseInterval * (1.0 + Float.random(in: -variation...variation))

        // 간단한 확률 기반 표시
        return Float.random(in: 0...1) < (0.1 / randomInterval)
    }

    func addDrop() {
        let randomizedVolume = viewModel.volume * (1.0 + Float.random(
            in: -viewModel.volumeVariation...viewModel.volumeVariation
        ))

        let drop = WaterDrop(
            volume: CGFloat(randomizedVolume),
            position: CGPoint(
                x: CGFloat.random(in: 60...140),
                y: 100
            )
        )
        drops.append(drop)
    }

    func cleanupOldDrops() {
        drops.removeAll { $0.createdAt.timeIntervalSinceNow < -2 }
    }
}

// MARK: - 물방울 모델

struct WaterDrop: Identifiable {
    let id = UUID()
    let volume: CGFloat
    let position: CGPoint
    let createdAt = Date()
}

// MARK: - 물방울 원 애니메이션

struct WaterDropCircle: View {
    let drop: WaterDrop
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0

    var body: some View {
        Circle()
            .stroke(Color.blue.opacity(0.6), lineWidth: 2)
            .frame(width: 10 + drop.volume * 30, height: 10 + drop.volume * 30)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(drop.position)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    scale = 3.0
                    opacity = 0.0
                }
            }
    }
}

// MARK: - 변동폭 범위 시각화 바

struct VariationRangeBar: View {
    let baseValue: Float
    let variation: Float
    let range: ClosedRange<Float>
    let color: Color
    let unit: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 범위 표시 바
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 전체 범위 배경
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.1))
                        .frame(height: 8)

                    // 가능한 변동 범위 (더 진한 색)
                    let minValue = max(range.lowerBound, baseValue * (1.0 - variation))
                    let maxValue = min(range.upperBound, baseValue * (1.0 + variation))

                    let minPosition = CGFloat((minValue - range.lowerBound) / (range.upperBound - range.lowerBound))
                    let maxPosition = CGFloat((maxValue - range.lowerBound) / (range.upperBound - range.lowerBound))
                    let width = (maxPosition - minPosition) * geometry.size.width

                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.4))
                        .frame(width: width, height: 8)
                        .offset(x: minPosition * geometry.size.width)

                    // 현재 기본값 표시
                    let currentPosition = CGFloat((baseValue - range.lowerBound) / (range.upperBound - range.lowerBound))

                    Circle()
                        .fill(color)
                        .frame(width: 16, height: 16)
                        .offset(x: currentPosition * geometry.size.width - 8)
                }
            }
            .frame(height: 16)

            // 범위 라벨
            HStack {
                Text(formatValue(value: baseValue * (1.0 - variation)))
                    .font(.system(size: 10))
                    .foregroundColor(color.opacity(0.7))

                Spacer()

                Text("기본: \(formatValue(value: baseValue))")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(color)

                Spacer()

                Text(formatValue(value: baseValue * (1.0 + variation)))
                    .font(.system(size: 10))
                    .foregroundColor(color.opacity(0.7))
            }
        }
        .padding(.horizontal, 4)
    }

    func formatValue(value: Float) -> String {
        return String(format: "%.1f%@", value, unit)
    }
}

// MARK: - 개선된 슬라이더 컨트롤 (시각화 포함)

@ViewBuilder
func enhancedSliderControl(
    icon: String,
    label: String,
    value: Binding<Float>,
    range: ClosedRange<Float>,
    step: Float,
    displayValue: String,
    color: Color,
    variationValue: Binding<Float>? = nil,
    unit: String = ""
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        // 기존 헤더
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(color)
                .frame(width: 20)

            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(.Text))

            Spacer()

            Text(displayValue)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(color)
                .frame(minWidth: 55, alignment: .trailing)
        }

        // 기본값 슬라이더
        Slider(value: value, in: range, step: step)
            .tint(color)

        // 변동폭 섹션
        if let variationValue = variationValue {
            Divider()
                .padding(.vertical, 4)

            // 변동폭 슬라이더 헤더
            HStack {
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 12))
                    .foregroundColor(color.opacity(0.7))

                Text("변화의 폭")
                    .font(.system(size: 13))
                    .foregroundColor(Color(.Text).opacity(0.8))

                Spacer()

                Text(String(format: "±%.0f%%", variationValue.wrappedValue * 100))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(color.opacity(0.7))
            }

            // 변동폭 슬라이더
            Slider(value: variationValue, in: 0.0...0.5, step: 0.05)
                .tint(color.opacity(0.6))

            // 시각화 바
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
    }
    .padding(12)
    .background(Color(.CircularSliderBackground).opacity(0.3))
    .cornerRadius(10)
}
