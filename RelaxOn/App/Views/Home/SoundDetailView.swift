//
//  SoundDetailView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI
import AVFoundation
import Combine

/**
 사용자가 Sound를 커스텀하는 View
 */
struct SoundDetailView: View {

    // MARK: - Properties
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: CustomSoundViewModel

    let isTutorial: Bool
    @State var progress: Double = 0.0
    @State var isShowingSheet: Bool = false
    @State var originalSound: OriginalSound
    @State private var filters: [AudioFilter] = []
    var editingSound: CustomSound? = nil
    var presetVariation: AudioVariation? = nil

    var isEditMode: Bool {
        editingSound != nil
    }

    var isPresetMode: Bool {
        presetVariation != nil
    }
    
    var body: some View {
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Text("당신이 원하는 소리를 찾아가보세요")
                            .foregroundColor(Color(.Text))
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 8)
                        Text("슬라이더를 조절하여 완벽한 소리를 만드세요")
                            .foregroundColor(Color(.Text).opacity(0.7))
                            .font(.system(size: 13, weight: .regular))
                    }

                    // 실시간 물방울 시각화
                    if viewModel.isPlaying {
                        WaterDropVisualization(viewModel: viewModel)
                            .padding(.vertical, 8)
                    } else {
                        // 사운드 이미지 (재생 중이 아닐 때)
                        soundImageView()
                    }

                    // 새로운 슬라이더 컨트롤
                    simpleSliderControls()
                        .padding(.bottom, 16)
                }
            }
            
            .navigationBarTitle(originalSound.name, displayMode: .inline)
            .font(.system(size: 24, weight: .bold))
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewModel.isPlaying {
                            viewModel.stopSound()
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color(.ChevronBack))
                            .frame(width: 30, height: 30)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                        isShowingSheet.toggle()
                    } label: {
                        Text("다음")
                            .foregroundColor(Color(.PrimaryPurple))
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)

            .fullScreenCover(isPresented: $isShowingSheet) {
                SoundSaveView(originalSound: originalSound, editingSound: editingSound)
            }
            
            // MARK: - Life Cycle
            .onAppear() {
                if UserDefaultsManager.shared.isFirstVisit {
                    UserDefaultsManager.shared.isFirstVisit = false
                }
                DispatchQueue.main.async {
                    viewModel.sound = originalSound
                    viewModel.filters = viewModel.filterDictionary[viewModel.sound.category]!

                    // 편집 모드일 경우 기존 값 로드
                    if isEditMode, let editing = editingSound {
                        viewModel.volume = editing.audioVariation.volume
                        viewModel.pitch = editing.audioVariation.pitch
                        viewModel.interval = editing.audioVariation.interval
                        viewModel.intervalVariation = editing.audioVariation.intervalVariation
                        viewModel.volumeVariation = editing.audioVariation.volumeVariation
                        viewModel.pitchVariation = editing.audioVariation.pitchVariation
                        viewModel.filter = editing.filter
                    }
                    // 프리셋 모드일 경우 프리셋 값 로드
                    else if isPresetMode, let preset = presetVariation {
                        viewModel.volume = preset.volume
                        viewModel.pitch = preset.pitch
                        viewModel.interval = preset.interval
                        viewModel.intervalVariation = preset.intervalVariation
                        viewModel.volumeVariation = preset.volumeVariation
                        viewModel.pitchVariation = preset.pitchVariation
                        // 프리셋의 필터는 originalSound에 이미 포함되어 있음
                    }

                    if !isTutorial {
                        viewModel.play(with: viewModel.sound)
                    }
                    viewModel.isFilterChanged = {
                        viewModel.play(with: viewModel.sound)
                    }
                }
            }
            .onDisappear {
                viewModel.stopSound()
                viewModel.filters.removeAll()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    @ViewBuilder
    func soundImageView() -> some View {
        Image(originalSound.category.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 100)
            .background(Color(hex: originalSound.color))
            .cornerRadius(12)
            .padding(.horizontal, 50)
    }

    @ViewBuilder
    func simpleSliderControls() -> some View {
        VStack(spacing: 16) {
            // 볼륨 슬라이더
            sliderControl(
                icon: "speaker.wave.2.fill",
                label: "볼륨",
                value: $viewModel.volume,
                range: 0.1...1.0,
                step: 0.01,
                displayValue: String(format: "%.0f%%", viewModel.volume * 100),
                color: .green,
                variationValue: $viewModel.volumeVariation
            )

            // 간격 슬라이더
            sliderControl(
                icon: "timer",
                label: "간격",
                value: $viewModel.interval,
                range: 0.1...2.0,
                step: 0.1,
                displayValue: String(format: "%.1f초", viewModel.interval),
                color: .blue,
                variationValue: $viewModel.intervalVariation
            )

            // 피치 슬라이더
            sliderControl(
                icon: "tuningfork",
                label: "피치",
                value: $viewModel.pitch,
                range: -5.0...5.0,
                step: 0.5,
                displayValue: String(format: "%+.1f", viewModel.pitch),
                color: .orange,
                variationValue: $viewModel.pitchVariation
            )

            // 필터 선택
            filterControl()
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    func sliderControl(
        icon: String,
        label: String,
        value: Binding<Float>,
        range: ClosedRange<Float>,
        step: Float,
        displayValue: String,
        color: Color,
        variationValue: Binding<Float>? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
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

            Slider(value: value, in: range, step: step)
                .tint(color)

            // 변동폭 슬라이더 (있는 경우에만)
            if let variationValue = variationValue {
                Divider()
                    .padding(.vertical, 4)

                HStack {
                    Image(systemName: "arrow.left.and.right")
                        .font(.system(size: 14))
                        .foregroundColor(color.opacity(0.7))
                        .frame(width: 20)

                    Text("변화의 폭")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.Text).opacity(0.8))

                    Spacer()

                    // 인디케이터
                    VariationIndicator(value: variationValue.wrappedValue, color: color)

                    Text(String(format: "±%.0f%%", variationValue.wrappedValue * 100))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(color.opacity(0.7))
                        .frame(minWidth: 45, alignment: .trailing)
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
                        unit: getUnit(for: label)
                    )
                    .padding(.top, 8)
                }
            }
        }
        .padding(12)
        .background(Color(.CircularSliderBackground).opacity(0.3))
        .cornerRadius(10)
    }

    // 라벨에 따라 적절한 단위 반환
    func getUnit(for label: String) -> String {
        switch label {
        case "볼륨":
            return "%"
        case "간격":
            return "초"
        case "피치":
            return ""
        default:
            return ""
        }
    }

    @ViewBuilder
    func filterControl() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "waveform")
                    .font(.system(size: 16))
                    .foregroundColor(.purple)
                    .frame(width: 20)

                Text("필터")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(.Text))

                Spacer()

                Text(viewModel.filter.rawValue)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.purple)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.filters, id: \.self) { filter in
                        filterButton(filter: filter)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.CircularSliderBackground).opacity(0.3))
        .cornerRadius(10)
    }

    @ViewBuilder
    func filterButton(filter: AudioFilter) -> some View {
        Button(action: {
            viewModel.filter = filter
        }) {
            Text(filter.rawValue)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(viewModel.filter == filter ? .white : Color(.Text))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    viewModel.filter == filter
                        ? Color.purple
                        : Color(.CircularSliderBackground)
                )
                .cornerRadius(20)
        }
    }
    
}

// MARK: - 물방울 실시간 시각화

struct WaterDropVisualization: View {
    @ObservedObject var viewModel: CustomSoundViewModel
    @State private var drops: [WaterDrop] = []
    @State private var audioEventCancellable: AnyCancellable?
    @State private var cleanupCancellable: AnyCancellable?

    var body: some View {
        ZStack(alignment: .top) {
            // 배경 그라데이션
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.2),
                            Color.blue.opacity(0.05),
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
                WaterDropCircle(drop: drop)
            }

            // 상단 정보 표시 (가로 배치)
            HStack(spacing: 8) {
                // 실시간 재생 아이콘
                HStack(spacing: 4) {
                    Image(systemName: "waveform.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(.PrimaryPurple))

                    Text("실시간 재생")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(.TitleText))
                }

                // 구분선
                Rectangle()
                    .fill(Color(.Text).opacity(0.2))
                    .frame(width: 1, height: 12)

                // 간격 표시
                Text(String(format: "%.1f초", viewModel.interval))
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(Color(.Text).opacity(0.8))

                // 변동폭 표시
                if viewModel.intervalVariation > 0 || viewModel.volumeVariation > 0 || viewModel.pitchVariation > 0 {
                    // 구분선
                    Rectangle()
                        .fill(Color(.Text).opacity(0.2))
                        .frame(width: 1, height: 12)

                    HStack(spacing: 4) {
                        Image(systemName: "dice.fill")
                            .font(.system(size: 10))
                        Text("변화")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(.orange.opacity(0.9))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(4)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.DefaultBackground).opacity(0.85))
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 1)
            )
            .padding(.top, 8)
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
        // AudioEngineManager의 실제 재생 이벤트 구독
        audioEventCancellable = AudioEngineManager.shared.soundDidPlay
            .receive(on: DispatchQueue.main)
            .sink { [self] volumeAndPitch in
                addDrop(volume: volumeAndPitch.volume, pitch: volumeAndPitch.pitch)
            }

        // 주기적으로 오래된 물방울 정리
        cleanupCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [self] _ in
                cleanupOldDrops()
            }
    }

    func stopVisualization() {
        audioEventCancellable?.cancel()
        cleanupCancellable?.cancel()
        drops.removeAll()
    }

    func addDrop(volume: Float, pitch: Float) {
        // 실제 사용 가능한 피치 범위로 화면 너비 매핑
        // 기본 피치 범위: -5 ~ +5
        // 최대 변동폭 50%: ±12 semitones
        // 실제 가능 범위: -17 ~ +17
        let minPitch: Float = -17.0
        let maxPitch: Float = 17.0
        let normalizedPitch = (pitch - minPitch) / (maxPitch - minPitch) // 0.0 ~ 1.0
        let xPosition = 20 + (normalizedPitch * 200) // 20 ~ 220 (전체 너비 활용)

        // 현재 사운드의 음원 길이 가져오기
        let soundDuration = viewModel.sound.filter.duration

        let drop = WaterDrop(
            volume: CGFloat(volume),
            pitch: CGFloat(pitch),
            position: CGPoint(
                x: CGFloat(xPosition),
                y: 120
            ),
            duration: soundDuration
        )

        drops.append(drop)
    }

    func cleanupOldDrops() {
        drops.removeAll { $0.createdAt.timeIntervalSinceNow < -2.5 }
    }
}

struct WaterDrop: Identifiable {
    let id = UUID()
    let volume: CGFloat
    let pitch: CGFloat
    let position: CGPoint
    let duration: TimeInterval // 음원 파일 길이
    let createdAt = Date()

    var color: Color {
        let normalized = (pitch + 24.0) / 48.0
        let hue = 0.55 + (normalized - 0.5) * 0.2
        return Color(hue: hue, saturation: 0.6, brightness: 0.8)
    }
}

struct WaterDropCircle: View {
    let drop: WaterDrop
    @State private var scale: CGFloat = 0.1
    @State private var opacity: Double = 1.0

    var body: some View {
        // 볼륨에 따른 크기 계산 (0.1 ~ 1.0 → 작은 원 ~ 큰 원)
        let baseSize = 30 + drop.volume * 50 // 30 ~ 80
        let lineThickness = 1.5 + drop.volume * 2.5 // 1.5 ~ 4.0

        Circle()
            .stroke(drop.color, lineWidth: lineThickness)
            .frame(width: baseSize, height: baseSize)
            .scaleEffect(scale)
            .opacity(opacity)
            .position(drop.position)
            .onAppear {
                // 음원 파일 길이에 맞춰 애니메이션 속도 동기화
                withAnimation(.easeOut(duration: drop.duration)) {
                    scale = 2.5
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

    var minValue: Float {
        max(range.lowerBound, baseValue * (1.0 - variation))
    }

    var maxValue: Float {
        min(range.upperBound, baseValue * (1.0 + variation))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.15))
                        .frame(height: 8)

                    let minPosition = CGFloat((minValue - range.lowerBound) / (range.upperBound - range.lowerBound))
                    let maxPosition = CGFloat((maxValue - range.lowerBound) / (range.upperBound - range.lowerBound))
                    let width = (maxPosition - minPosition) * geometry.size.width

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    color.opacity(0.4),
                                    color.opacity(0.6),
                                    color.opacity(0.4)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: width, height: 8)
                        .offset(x: minPosition * geometry.size.width)

                    let currentPosition = CGFloat((baseValue - range.lowerBound) / (range.upperBound - range.lowerBound))

                    ZStack {
                        Circle()
                            .fill(color)
                            .frame(width: 16, height: 16)

                        Circle()
                            .fill(Color.white)
                            .frame(width: 6, height: 6)
                    }
                    .offset(x: currentPosition * geometry.size.width - 8)
                }
            }
            .frame(height: 20)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("최소")
                        .font(.system(size: 9))
                        .foregroundColor(Color(.Text).opacity(0.5))
                    Text(formatValue(value: minValue))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(color.opacity(0.8))
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("기본")
                        .font(.system(size: 9))
                        .foregroundColor(Color(.Text).opacity(0.5))
                    Text(formatValue(value: baseValue))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(color)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("최대")
                        .font(.system(size: 9))
                        .foregroundColor(Color(.Text).opacity(0.5))
                    Text(formatValue(value: maxValue))
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(color.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 4)
    }

    func formatValue(value: Float) -> String {
        if unit == "초" {
            return String(format: "%.1f%@", value, unit)
        } else if unit == "%" {
            return String(format: "%.0f%@", value * 100, unit)
        } else if unit.isEmpty {
            return String(format: "%+.1f", value)
        } else {
            return String(format: "%.1f%@", value, unit)
        }
    }
}

struct VariationIndicator: View {
    let value: Float
    let color: Color

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<5) { index in
                let threshold = Float(index) * 0.1
                let isActive = value >= threshold

                RoundedRectangle(cornerRadius: 2)
                    .fill(isActive ? color : Color.gray.opacity(0.2))
                    .frame(width: 4, height: CGFloat(8 + index * 3))
                    .animation(.easeInOut(duration: 0.2), value: isActive)
            }
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(isTutorial: true, originalSound: OriginalSound(name: "물방울", filter: .WaterDrop, category: .WaterDrop))
            .environmentObject(CustomSoundViewModel())
    }
}
