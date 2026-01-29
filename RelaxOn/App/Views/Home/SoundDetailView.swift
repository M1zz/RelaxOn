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
                        Text(L.Customize.findYourSound.localized)
                            .foregroundColor(Color(.Text))
                            .font(.system(size: 18, weight: .bold))
                            .padding(.top, 8)
                        Text(L.Customize.adjustSlider.localized)
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
                        Text(L.Common.next.localized)
                            .foregroundColor(Color(.PrimaryPurple))
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)

            .navigationDestination(isPresented: $isShowingSheet) {
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
                label: L.Customize.volume.localized,
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
                label: L.Customize.interval.localized,
                value: $viewModel.interval,
                range: 0.1...2.0,
                step: 0.1,
                displayValue: String(format: "%.1f%@", viewModel.interval, L.Customize.seconds.localized),
                color: .blue,
                variationValue: $viewModel.intervalVariation
            )

            // 피치 슬라이더
            sliderControl(
                icon: "tuningfork",
                label: L.Customize.pitch.localized,
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

                    Text(L.Customize.variationRange.localized)
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
        case L.Customize.volume.localized:
            return "%"
        case L.Customize.interval.localized:
            return L.Customize.seconds.localized
        case L.Customize.pitch.localized:
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

                Text(L.Common.filter.localized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(.Text))

                Spacer()

                Text(viewModel.filter.displayName)
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
            Text(filter.displayName)
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

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(isTutorial: true, originalSound: OriginalSound(name: "물방울", filter: .WaterDrop, category: .WaterDrop))
            .environmentObject(CustomSoundViewModel())
    }
}
