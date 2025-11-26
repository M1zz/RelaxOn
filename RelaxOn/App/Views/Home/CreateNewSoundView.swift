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
    @StateObject private var viewModel = CreateSoundViewModel()
    @State private var isTargeted = false

    var body: some View {
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 헤더
                headerView()

                ScrollView {
                    VStack(spacing: 24) {
                        // 빈 캔버스 (물방울 프리뷰)
                        emptyCanvasView()

                        // 드래그 앤 드롭 영역
                        dropZoneView()

                        // 추가된 사운드 레이어들
                        if !viewModel.addedSounds.isEmpty {
                            addedSoundsSection()
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("뒤로")
                        .font(.system(size: 16))
                }
                .foregroundColor(Color(.PrimaryPurple))
            }

            Spacer()

            Text("새 사운드 만들기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(.TitleText))

            Spacer()

            Button(action: {
                // 저장 로직
            }) {
                Text("완료")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(viewModel.addedSounds.isEmpty ? Color(.Text).opacity(0.3) : Color(.PrimaryPurple))
            }
            .disabled(viewModel.addedSounds.isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(.DefaultBackground))
    }

    // MARK: - Empty Canvas
    @ViewBuilder
    private func emptyCanvasView() -> some View {
        VStack(spacing: 16) {
            Text("미리보기")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.Text).opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)

            ZStack {
                // 배경 그라데이션
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(.PrimaryPurple).opacity(0.05),
                                Color.blue.opacity(0.03)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // 물방울 프리뷰 (빈 상태)
                if viewModel.addedSounds.isEmpty {
                    emptyStateView()
                } else {
                    // 레이어된 사운드들의 시각화
                    layeredVisualizationView()
                }
            }
            .frame(height: 280)
        }
    }

    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack(spacing: 12) {
            ZStack {
                // 빈 물방울 윤곽선들
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .stroke(
                            Color.blue.opacity(0.15 - Double(index) * 0.05),
                            style: StrokeStyle(lineWidth: 2, dash: [5, 5])
                        )
                        .frame(width: CGFloat(60 + index * 40), height: CGFloat(60 + index * 40))
                }
            }

            VStack(spacing: 6) {
                Text("아직 사운드가 없습니다")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color(.Text).opacity(0.5))

                Text("아래에서 원본 사운드를 선택해주세요")
                    .font(.system(size: 13))
                    .foregroundColor(Color(.Text).opacity(0.4))
            }
        }
    }

    @ViewBuilder
    private func layeredVisualizationView() -> some View {
        ZStack {
            // 여러 레이어의 물방울들이 동시에 보이는 효과
            ForEach(Array(viewModel.addedSounds.enumerated()), id: \.offset) { index, sound in
                Circle()
                    .stroke(
                        sound.color.opacity(0.6),
                        lineWidth: 3
                    )
                    .frame(width: 80, height: 80)
                    .scaleEffect(1.0 + Double(index) * 0.3)
                    .opacity(0.8 - Double(index) * 0.2)
            }

            // 중앙 정보
            VStack(spacing: 8) {
                Text("\(viewModel.addedSounds.count)개 레이어")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(.TitleText))

                HStack(spacing: 4) {
                    Image(systemName: "layers.fill")
                        .font(.system(size: 12))
                    Text("탭하여 편집")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color(.Text).opacity(0.6))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.DefaultBackground).opacity(0.95))
                    .shadow(color: Color.black.opacity(0.1), radius: 8)
            )
        }
    }

    // MARK: - Drop Zone
    @ViewBuilder
    private func dropZoneView() -> some View {
        VStack(spacing: 16) {
            Text("원본 사운드 선택")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(.Text).opacity(0.6))
                .frame(maxWidth: .infinity, alignment: .leading)

            // 드래그 앤 드롭 영역
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(viewModel.availableSounds) { sound in
                    OriginalSoundCard(sound: sound) {
                        viewModel.addSound(sound)
                    }
                }
            }
        }
    }

    // MARK: - Added Sounds Section
    @ViewBuilder
    private func addedSoundsSection() -> some View {
        VStack(spacing: 16) {
            HStack {
                Text("추가된 레이어")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(.Text).opacity(0.6))

                Spacer()

                Text("\(viewModel.addedSounds.count)개")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(.PrimaryPurple))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(.PrimaryPurple).opacity(0.1))
                    .cornerRadius(8)
            }

            VStack(spacing: 12) {
                ForEach(Array(viewModel.addedSounds.enumerated()), id: \.offset) { index, sound in
                    AddedSoundRow(
                        sound: sound,
                        index: index,
                        onTap: {
                            viewModel.selectSoundForEdit(sound)
                        },
                        onRemove: {
                            viewModel.removeSound(sound)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Original Sound Card

struct OriginalSoundCard: View {
    let sound: AvailableSound
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(sound.color.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: sound.icon)
                        .font(.system(size: 22))
                        .foregroundColor(sound.color)
                }

                // 이름
                Text(sound.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(.TitleText))
                    .lineLimit(1)

                // Duration
                Text(String(format: "%.1fs", sound.duration))
                    .font(.system(size: 10))
                    .foregroundColor(Color(.Text).opacity(0.5))
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(
                        color: isPressed ? sound.color.opacity(0.3) : Color.black.opacity(0.06),
                        radius: isPressed ? 8 : 4,
                        x: 0,
                        y: 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(sound.color.opacity(isPressed ? 0.4 : 0.0), lineWidth: 2)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.0, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// MARK: - Added Sound Row

struct AddedSoundRow: View {
    let sound: AddedSound
    let index: Int
    let onTap: () -> Void
    let onRemove: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // 순서 번호
                Text("\(index + 1)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(sound.color)
                    )

                // 아이콘 & 이름
                HStack(spacing: 12) {
                    Image(systemName: sound.icon)
                        .font(.system(size: 18))
                        .foregroundColor(sound.color)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(sound.name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(.TitleText))

                        if sound.isCustomized {
                            HStack(spacing: 4) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 10))
                                Text("커스터마이징됨")
                                    .font(.system(size: 11))
                            }
                            .foregroundColor(Color(.PrimaryPurple).opacity(0.8))
                        } else {
                            Text("탭하여 커스터마이징")
                                .font(.system(size: 11))
                                .foregroundColor(Color(.Text).opacity(0.5))
                        }
                    }
                }

                Spacer()

                // 삭제 버튼
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color(.Text).opacity(0.3))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(sound.isCustomized ? Color(.PrimaryPurple).opacity(0.2) : Color.clear, lineWidth: 1.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - View Models

class CreateSoundViewModel: ObservableObject {
    @Published var availableSounds: [AvailableSound] = []
    @Published var addedSounds: [AddedSound] = []
    @Published var selectedSound: AddedSound?

    init() {
        loadAvailableSounds()
    }

    private func loadAvailableSounds() {
        availableSounds = [
            AvailableSound(
                id: "waterdrop",
                name: "물방울",
                icon: "drop.fill",
                color: .blue,
                category: .WaterDrop,
                filter: .WaterDrop,
                duration: 1.0
            ),
            AvailableSound(
                id: "basement",
                name: "지하실",
                icon: "building.fill",
                color: .cyan,
                category: .WaterDrop,
                filter: .Basement,
                duration: 2.0
            ),
            AvailableSound(
                id: "cave",
                name: "동굴",
                icon: "moon.fill",
                color: .indigo,
                category: .WaterDrop,
                filter: .Cave,
                duration: 1.5
            ),
            AvailableSound(
                id: "pipe",
                name: "파이프",
                icon: "cylinder.fill",
                color: .teal,
                category: .WaterDrop,
                filter: .Pipe,
                duration: 1.2
            ),
            AvailableSound(
                id: "sink",
                name: "싱크대",
                icon: "rectangle.fill",
                color: .mint,
                category: .WaterDrop,
                filter: .Sink,
                duration: 1.8
            ),
            AvailableSound(
                id: "bowl",
                name: "싱잉볼",
                icon: "circle.circle",
                color: .purple,
                category: .SingingBowl,
                filter: .SingingBowl,
                duration: 3.0
            ),
            AvailableSound(
                id: "bird",
                name: "새",
                icon: "bird.fill",
                color: .green,
                category: .Bird,
                filter: .Bird,
                duration: 2.5
            ),
            AvailableSound(
                id: "owl",
                name: "부엉이",
                icon: "moon.stars.fill",
                color: .brown,
                category: .Bird,
                filter: .Owl,
                duration: 2.0
            ),
            AvailableSound(
                id: "woodpecker",
                name: "딱따구리",
                icon: "leaf.fill",
                color: .orange,
                category: .Bird,
                filter: .Woodpecker,
                duration: 0.8
            )
        ]
    }

    func addSound(_ sound: AvailableSound) {
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

// MARK: - Preview

struct CreateNewSoundView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateNewSoundView()
        }
    }
}
