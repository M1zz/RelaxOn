//
//  SoundPlayerFullModalView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 풀 모달 화면으로 보여지는 음원 플레이어 VIew
 */
struct SoundPlayerFullModalView: View {

    @EnvironmentObject var viewModel: CustomSoundViewModel
    @ObservedObject private var audioManager = AudioEngineManager.shared

    @State private var showSpatialControls = false
    @State private var layerPositions: [LayerPosition] = []

    struct LayerPosition: Identifiable {
        let id = UUID()
        let layerIndex: Int
        let layerName: String
        var distance: Float
        var angle: Float
        var height: Float
    }

    var body: some View {
        VStack {
            Spacer()
            
            Image(viewModel.selectedSound?.category.imageName ?? viewModel.lastSound.category.imageName)
                .resizable()
                .scaledToFit()
                .background(Color(hex: viewModel.selectedSound?.color ?? viewModel.lastSound.color))
                .cornerRadius(12)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 8)
            
            Spacer()
            
            Text(viewModel.selectedSound?.title ?? viewModel.lastSound.title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color(.Text))
            
            HStack(alignment: .center, spacing: 40) {
                
                Button {
                    viewModel.playPreviousSound()
                } label: {
                    Image(PlayerButton.fastRewind.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
                
                Button {
                    if viewModel.isPlaying {
                        viewModel.stopSound()
                    } else {
                        viewModel.play(with: viewModel.selectedSound ?? viewModel.lastSound)
                    }
                } label: {
                    Image(viewModel.playPauseStatusImage)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
                
                Button {
                    viewModel.playNextSound()
                } label: {
                    Image(PlayerButton.fastForward.rawValue)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color(.Text))
                        .frame(width: 40, height: 40)
                        .scaledToFit()
                }
            }
            .frame(minWidth: 200, maxWidth: .infinity)
            .padding(.top, 32)

            // Spatial Audio Toggle
            VStack(spacing: 12) {
                Toggle(isOn: $audioManager.isSpatialAudioEnabled) {
                    HStack(spacing: 8) {
                        Image(systemName: "spatial.audio")
                            .font(.system(size: 18))
                        Text("공간 음향")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color(.Text))
                }
                .toggleStyle(SwitchToggleStyle(tint: Color(.PrimaryPurple)))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.DefaultBackground).opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.Text).opacity(0.1), lineWidth: 1)
                        )
                )
                .onChange(of: audioManager.isSpatialAudioEnabled) { _ in
                    // 공간음향 설정 변경 시 즉시 적용을 위해 재생 중인 사운드를 재시작
                    if viewModel.isPlaying {
                        let currentSound = viewModel.selectedSound ?? viewModel.lastSound
                        viewModel.stopSound()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            viewModel.play(with: currentSound)
                        }
                    }
                }

                if audioManager.isSpatialAudioEnabled {
                    Text("3D 입체 음향이 활성화되어 있습니다")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.Text).opacity(0.6))

                    // 위치 조정 버튼
                    Button {
                        withAnimation {
                            showSpatialControls.toggle()
                        }
                    } label: {
                        HStack {
                            Text("위치 조정")
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: showSpatialControls ? "chevron.up" : "chevron.down")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Color(.PrimaryPurple))
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.top, 24)
            .padding(.horizontal, 16)

            // 레이어별 위치 조정 컨트롤
            if audioManager.isSpatialAudioEnabled && showSpatialControls {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach($layerPositions) { $position in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("레이어 \(position.layerIndex + 1): \(position.layerName)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(.Text))

                                    Spacer()

                                    // 레이어 제거 버튼
                                    Button(action: {
                                        removeLayer(at: position.layerIndex)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.red)
                                    }
                                }

                                // 거리 슬라이더
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("거리")
                                            .font(.system(size: 12))
                                        Spacer()
                                        Text("\(String(format: "%.1f", position.distance))m")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(Color(.Text).opacity(0.7))

                                    Slider(value: $position.distance, in: 0.5...5.0, step: 0.1)
                                        .accentColor(Color(.PrimaryPurple))
                                        .onChange(of: position.distance) { newValue in
                                            audioManager.updateLayerPosition(
                                                index: position.layerIndex,
                                                distance: newValue,
                                                angle: position.angle,
                                                height: position.height
                                            )
                                        }
                                }

                                // 각도 슬라이더
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("각도")
                                            .font(.system(size: 12))
                                        Spacer()
                                        Text("\(Int(position.angle))°")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(Color(.Text).opacity(0.7))

                                    Slider(value: $position.angle, in: 0...360, step: 5)
                                        .accentColor(Color(.PrimaryPurple))
                                        .onChange(of: position.angle) { newValue in
                                            audioManager.updateLayerPosition(
                                                index: position.layerIndex,
                                                distance: position.distance,
                                                angle: newValue,
                                                height: position.height
                                            )
                                        }
                                }

                                // 높이 슬라이더
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("높이")
                                            .font(.system(size: 12))
                                        Spacer()
                                        Text("\(String(format: "%.1f", position.height))m")
                                            .font(.system(size: 12, weight: .medium))
                                    }
                                    .foregroundColor(Color(.Text).opacity(0.7))

                                    Slider(value: $position.height, in: -2.0...2.0, step: 0.1)
                                        .accentColor(Color(.PrimaryPurple))
                                        .onChange(of: position.height) { newValue in
                                            audioManager.updateLayerPosition(
                                                index: position.layerIndex,
                                                distance: position.distance,
                                                angle: position.angle,
                                                height: newValue
                                            )
                                        }
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.DefaultBackground).opacity(0.5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(.Text).opacity(0.1), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .frame(maxHeight: 300)
            }

            Spacer()

        }
        .padding(.horizontal, 24)
        .padding(.vertical, 32)
        .background(Color(.DefaultBackground))
        
        .onAppear {
            if let selectedSound = viewModel.selectedSound {
                viewModel.lastSound = selectedSound
            }

            // 레이어 위치 정보 초기화
            initializeLayerPositions()

            if viewModel.isPlaying {
                viewModel.stopSound()
                viewModel.play(with: viewModel.selectedSound ?? viewModel.lastSound)
            } else {
                viewModel.play(with: viewModel.selectedSound ?? viewModel.lastSound)
            }
        }
        .onDisappear {
            if let selectedSound = viewModel.selectedSound {
                viewModel.lastSound = selectedSound
            }
        }
    }

    // MARK: - Helper Methods

    /// 레이어 제거
    private func removeLayer(at index: Int) {
        // AudioEngineManager의 레이어 제거 메서드 호출
        audioManager.removeLayer(at: index)

        // UI 업데이트
        withAnimation {
            initializeLayerPositions()
        }

        print("🗑️ [SoundPlayerFullModalView] 레이어 \(index) 제거")
    }

    private func initializeLayerPositions() {
        let currentSound = viewModel.selectedSound ?? viewModel.lastSound

        // 레이어 사운드인 경우에만 초기화
        guard let layers = currentSound.soundLayers, !layers.isEmpty else {
            layerPositions = []
            return
        }

        // AudioEngineManager에서 현재 레이어 위치 정보 가져오기
        let positions = audioManager.getLayerPositions()

        layerPositions = layers.enumerated().map { index, layer in
            let layerName = "\(layer.category.displayName) - \(layer.filter.rawValue)"

            // 현재 위치 가져오기 (없으면 기본값 사용)
            var distance: Float = 2.0
            var angle: Float = 0.0
            var height: Float = 0.0

            if index < positions.count {
                let pos = positions[index].position
                // 직교좌표를 극좌표로 변환
                distance = sqrt(pos.x * pos.x + pos.z * pos.z)
                angle = atan2(-pos.z, pos.x) * 180.0 / .pi
                if angle < 0 {
                    angle += 360
                }
                height = pos.y
            } else {
                // 기본 원형 배치
                let totalLayers = Float(layers.count)
                angle = (360.0 / totalLayers) * Float(index)
            }

            return LayerPosition(
                layerIndex: index,
                layerName: layerName,
                distance: distance,
                angle: angle,
                height: height
            )
        }
    }
}

struct FullModalSoundPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        SoundPlayerFullModalView()
    }
}
