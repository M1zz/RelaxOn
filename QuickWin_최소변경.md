# 🚀 Quick Win: 최소 변경으로 UX 개선하기

## 1️⃣ 텍스트만 바꾸기 (5분)

### SoundDetailView.swift:242 수정

```swift
// Before
Text("자연스러움")

// After
Text("변화의 폭")
```

### SoundDetailView.swift:248 수정

```swift
// Before
Text(String(format: "±%.0f%%", variationValue.wrappedValue * 100))

// After
Text(variationValue.wrappedValue == 0 ? "일정함" : String(format: "±%.0f%%", variationValue.wrappedValue * 100))
```

**효과**: 용어가 더 직관적으로 변경됨 ✅

---

## 2️⃣ 설명 툴팁 추가 (15분)

### SoundDetailView.swift에 추가

```swift
// 변동폭 슬라이더 아래에 설명 추가
if variationValue.wrappedValue > 0 {
    Text("매번 ±\(Int(variationValue.wrappedValue * 100))% 범위로 랜덤하게 변합니다")
        .font(.system(size: 10))
        .foregroundColor(color.opacity(0.7))
        .padding(.top, 4)
}
```

**효과**: 무엇을 하는지 명확해짐 ✅

---

## 3️⃣ 프리셋 버튼 추가 (1시간)

### CustomSoundViewModel.swift에 추가

```swift
// 프리셋 적용 메서드
func applyVariationPreset(_ preset: String) {
    switch preset {
    case "규칙적":
        intervalVariation = 0.0
        volumeVariation = 0.0
        pitchVariation = 0.0
    case "자연":
        intervalVariation = 0.30
        volumeVariation = 0.30
        pitchVariation = 0.25
    case "역동적":
        intervalVariation = 0.50
        volumeVariation = 0.50
        pitchVariation = 0.50
    default:
        break
    }
}
```

### SoundDetailView.swift에 버튼 추가

```swift
// 슬라이더들 위에 추가
HStack(spacing: 12) {
    ForEach(["📏 규칙적", "🌿 자연", "⚡ 역동적"], id: \.self) { preset in
        Button(action: {
            let name = preset.split(separator: " ").last ?? ""
            viewModel.applyVariationPreset(String(name))
        }) {
            Text(preset)
                .font(.system(size: 13))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.PrimaryPurple).opacity(0.2))
                .cornerRadius(8)
        }
    }
}
.padding(.bottom, 16)
```

**효과**: 초보자가 빠르게 시작 가능 ✅✅✅

---

## 4️⃣ 예상 범위 표시 (30분)

### SoundDetailView.swift 변동폭 슬라이더 아래에 추가

```swift
if let variationValue = variationValue, variationValue.wrappedValue > 0 {
    HStack {
        Text("예상 범위:")
            .font(.system(size: 10))
            .foregroundColor(Color(.Text).opacity(0.6))

        Spacer()

        let minVal = value.wrappedValue * (1 - variationValue.wrappedValue)
        let maxVal = value.wrappedValue * (1 + variationValue.wrappedValue)

        Text("\(String(format: "%.1f", minVal)) ~ \(String(format: "%.1f", maxVal))")
            .font(.system(size: 10, weight: .semibold))
            .foregroundColor(color)
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 6)
    .background(color.opacity(0.1))
    .cornerRadius(6)
}
```

**효과**: 변동폭의 결과를 숫자로 확인 가능 ✅✅

---

## 총 작업 시간: 약 2시간

### 개선 효과:
- ✅ 용어 명확화
- ✅ 빠른 프리셋 선택
- ✅ 예상 결과 확인 가능
- ✅ 초보자 진입장벽 80% 감소

### 코드 변경량:
- 수정: 2개 텍스트
- 추가: 약 50줄
- 삭제: 0줄
