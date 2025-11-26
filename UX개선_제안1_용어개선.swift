// UX 개선안 1: 직관적인 용어와 설명

// MARK: - 개선된 Variation 슬라이더

@ViewBuilder
func improvedVariationSlider(
    value: Binding<Float>,
    color: Color,
    parameterType: VariationType
) -> some View {
    VStack(alignment: .leading, spacing: 6) {
        HStack {
            Image(systemName: "waveform.path.ecg")
                .font(.system(size: 13))
                .foregroundColor(color.opacity(0.7))

            Text(parameterType.displayName)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(.Text).opacity(0.8))

            Spacer()

            // 시각적 인디케이터
            variationIndicator(value: value.wrappedValue, color: color)
        }

        // 슬라이더
        Slider(value: value, in: 0.0...0.5, step: 0.05)
            .tint(color.opacity(0.6))

        // 범위 라벨
        HStack {
            Text(parameterType.minLabel)
                .font(.system(size: 10))
                .foregroundColor(Color(.Text).opacity(0.5))

            Spacer()

            Text(parameterType.maxLabel)
                .font(.system(size: 10))
                .foregroundColor(Color(.Text).opacity(0.5))
        }

        // 설명 툴팁
        if value.wrappedValue > 0 {
            Text(parameterType.explanation(value: value.wrappedValue))
                .font(.system(size: 11))
                .foregroundColor(color.opacity(0.8))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.1))
                .cornerRadius(6)
        }
    }
}

// MARK: - 시각적 인디케이터

@ViewBuilder
func variationIndicator(value: Float, color: Color) -> some View {
    HStack(spacing: 3) {
        // 5개의 바로 변동폭 표시
        ForEach(0..<5) { index in
            RoundedRectangle(cornerRadius: 2)
                .fill(value >= Float(index) * 0.1 ? color : Color.gray.opacity(0.2))
                .frame(width: 4, height: Float(index + 1) * 3)
        }
    }
}

// MARK: - 타입별 설명

enum VariationType {
    case interval
    case volume
    case pitch

    var displayName: String {
        switch self {
        case .interval: return "간격 변화"
        case .volume: return "크기 변화"
        case .pitch: return "음높이 변화"
        }
    }

    var minLabel: String {
        switch self {
        case .interval: return "규칙적"
        case .volume: return "일정함"
        case .pitch: return "같은 음"
        }
    }

    var maxLabel: String {
        switch self {
        case .interval: return "불규칙"
        case .volume: return "다양함"
        case .pitch: return "여러 음"
        }
    }

    func explanation(value: Float) -> String {
        let percentage = Int(value * 100)
        switch self {
        case .interval:
            return "매번 ±\(percentage)% 범위로 타이밍이 변합니다"
        case .volume:
            return "매번 ±\(percentage)% 범위로 크기가 변합니다"
        case .pitch:
            return "매번 약 ±\(Int(Float(percentage) * 0.24))개 음으로 변합니다"
        }
    }
}
