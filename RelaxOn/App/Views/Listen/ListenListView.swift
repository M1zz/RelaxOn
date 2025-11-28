//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

/**
 커스텀 음원 목록이 노출되는 View
 하단 플레이어 바를 통해 음원 재생, 정지 기능
 */
struct ListenListView: View {

    @EnvironmentObject var viewModel: CustomSoundViewModel
    @State private var searchText = ""

    @State private var selectedFile = CustomSound()
    @State private var isShowingSheet = false
    @State private var isShowingPlayer = false
    @State private var editingSound: CustomSound? = nil
    @State private var isShowingEditView = false
    @State private var isShowingCreateModal = false
    @State private var isShowingSettings = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.05, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.15, blue: 0.25)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // 헤더
                headerView()

                // 캠프파이어 중앙 배치 (사운드 바 공간 확보)
                CampfireView(isPlaying: viewModel.isPlaying)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 100) // 사운드 바 높이만큼 패딩

                // 하단 미니 플레이어 (항상 표시)
                if viewModel.isPlaying {
                    miniPlayerView()
                } else {
                    emptyPlayerView()
                }
            }
        }

        .sheet(isPresented: $isShowingEditView) {
            if let editing = editingSound {
                NavigationView {
                    SoundDetailView(
                        isTutorial: false,
                        originalSound: OriginalSound(
                            name: editing.category.displayName,
                            filter: editing.filter,
                            category: editing.category
                        ),
                        editingSound: editing
                    )
                }
            }
        }

        .sheet(isPresented: $isShowingCreateModal) {
            createSoundModal()
        }

        .sheet(isPresented: $isShowingSettings) {
            NavigationStack {
                TimerMainView()
                    .navigationTitle("타이머")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("닫기") {
                                isShowingSettings = false
                            }
                        }
                    }
            }
        }

        .onAppear {
            selectedFile = viewModel.lastSound
            viewModel.loadSound()
        }
    }

    // MARK: - Helper Views

    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 64))
                    .foregroundColor(Color(.Text).opacity(0.3))

                VStack(spacing: 8) {
                    Text("저장된 사운드가 없어요")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(.TitleText))

                    Text("나만의 첫 사운드를 만들어보세요")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.Text).opacity(0.6))
                }

                Button(action: {
                    isShowingCreateModal = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text("첫 사운드 만들기")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(Color(.PrimaryPurple))
                    .cornerRadius(12)
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.DefaultBackground))
    }

    @ViewBuilder
    private func createSoundModal() -> some View {
        NavigationStack {
            SavedSoundsListView()
        }
    }

    // MARK: - Header View
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Text("듣기")
                .foregroundColor(.white)
                .font(.system(size: 28, weight: .bold))

            Spacer()

            // 새로 만들기 버튼
            Button(action: {
                isShowingCreateModal = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.PrimaryPurple))
            }
            .padding(.trailing, 12)

            // 설정 버튼
            Button(action: {
                isShowingSettings = true
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    // MARK: - Mini Player View
    @ViewBuilder
    private func miniPlayerView() -> some View {
        Button {
            isShowingSheet = true
        } label: {
            HStack(spacing: 16) {
                // 앨범 아트 (작은 캠프파이어)
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.orange.opacity(0.3),
                                    Color.red.opacity(0.2)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 50, height: 50)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.orange)
                }

                // 사운드 정보
                VStack(alignment: .leading, spacing: 4) {
                    if let sound = viewModel.selectedSound as? CustomSound {
                        Text(sound.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Text(sound.category.displayName)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Spacer()

                // 재생/일시정지 버튼
                Button(action: {
                    if viewModel.isPlaying {
                        viewModel.stopSound()
                    } else {
                        if let sound = viewModel.selectedSound {
                            viewModel.play(with: sound)
                        }
                    }
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.4))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $isShowingSheet, onDismiss: {
            isShowingSheet = false
        }) {
            SoundPlayerFullModalView()
        }
    }

    // MARK: - Empty Player View
    @ViewBuilder
    private func emptyPlayerView() -> some View {
        Button {
            isShowingCreateModal = true
        } label: {
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "music.note")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.6))

                    Text("사운드를 선택하여 재생해보세요")
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black.opacity(0.3))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Campfire View

struct CampfireView: View {
    let isPlaying: Bool
    @State private var flameScale1: CGFloat = 1.0
    @State private var flameScale2: CGFloat = 1.0
    @State private var flameScale3: CGFloat = 1.0
    @State private var flameScale4: CGFloat = 1.0
    @State private var flameScale5: CGFloat = 1.0
    @State private var flameOpacity1: Double = 0.9
    @State private var flameOpacity2: Double = 0.7
    @State private var flameOpacity3: Double = 0.5
    @State private var flameOpacity4: Double = 0.3
    @State private var flameOpacity5: Double = 0.2
    @State private var glowIntensity: CGFloat = 0.3
    @State private var sparkOffset1: CGFloat = 0
    @State private var sparkOffset2: CGFloat = 0
    @State private var sparkOpacity1: Double = 0.0
    @State private var sparkOpacity2: Double = 0.0

    var body: some View {
        ZStack {
            // 바닥 빛 반사 (glow effect)
            if isPlaying {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(glowIntensity * 0.4),
                                Color.red.opacity(glowIntensity * 0.2),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 20,
                            endRadius: 150
                        )
                    )
                    .frame(width: 300, height: 150)
                    .offset(y: 80)
                    .blur(radius: 20)
            }

            // 불꽃들 (5개 레이어로 깊이감 증대)
            ZStack {
                // 가장 뒤 불꽃 (레드 계열)
                Image(systemName: "flame.fill")
                    .font(.system(size: 140))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.red.opacity(0.3),
                                Color.orange.opacity(0.2)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .scaleEffect(flameScale5)
                    .opacity(flameOpacity5)
                    .offset(y: -5)
                    .blur(radius: 3)

                // 뒤에서 두번째 불꽃
                Image(systemName: "flame.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.4),
                                Color.yellow.opacity(0.3)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .scaleEffect(flameScale4)
                    .opacity(flameOpacity4)
                    .offset(y: -8)
                    .blur(radius: 2)

                // 중간 불꽃
                Image(systemName: "flame.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.orange.opacity(0.7),
                                Color.yellow.opacity(0.5)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .scaleEffect(flameScale3)
                    .opacity(flameOpacity3)
                    .offset(y: -10)
                    .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 0)

                // 앞에서 두번째 불꽃
                Image(systemName: "flame.fill")
                    .font(.system(size: 85))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.orange,
                                Color.yellow.opacity(0.8)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .scaleEffect(flameScale2)
                    .opacity(flameOpacity2)
                    .offset(y: -12)
                    .shadow(color: .orange.opacity(0.7), radius: 15, x: 0, y: 0)

                // 가장 앞 불꽃 (가장 밝음)
                Image(systemName: "flame.fill")
                    .font(.system(size: 75))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.yellow,
                                Color.white.opacity(0.9)
                            ]),
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .scaleEffect(flameScale1)
                    .opacity(flameOpacity1)
                    .offset(y: -15)
                    .shadow(color: .yellow.opacity(0.8), radius: 20, x: 0, y: 0)

                // 불꽃 파편들 (sparkles)
                if isPlaying {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 4, height: 4)
                        .offset(x: -30, y: sparkOffset1 - 50)
                        .opacity(sparkOpacity1)
                        .blur(radius: 1)

                    Circle()
                        .fill(Color.orange)
                        .frame(width: 3, height: 3)
                        .offset(x: 25, y: sparkOffset2 - 45)
                        .opacity(sparkOpacity2)
                        .blur(radius: 1)
                }
            }

            // 장작 (더 입체적으로)
            VStack(spacing: 4) {
                Spacer()

                ZStack {
                    // 뒤쪽 장작
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.35, green: 0.2, blue: 0.1),
                                    Color(red: 0.25, green: 0.15, blue: 0.05)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 70, height: 14)
                        .rotationEffect(.degrees(-20))
                        .offset(x: -15, y: 5)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: -2, y: 3)

                    // 오른쪽 장작
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.4, green: 0.25, blue: 0.1),
                                    Color(red: 0.3, green: 0.18, blue: 0.08)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 75, height: 15)
                        .rotationEffect(.degrees(18))
                        .offset(x: 20, y: 8)
                        .shadow(color: .black.opacity(0.6), radius: 5, x: 2, y: 4)

                    // 왼쪽 장작
                    RoundedRectangle(cornerRadius: 5)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.38, green: 0.23, blue: 0.12),
                                    Color(red: 0.28, green: 0.16, blue: 0.07)
                                ]),
                                startPoint: .topTrailing,
                                endPoint: .bottomLeading
                            )
                        )
                        .frame(width: 65, height: 13)
                        .rotationEffect(.degrees(-12))
                        .offset(x: -8, y: 12)
                        .shadow(color: .black.opacity(0.4), radius: 4, x: -1, y: 3)
                }
                .offset(y: 40)
            }

            // 재생 중일 때만 텍스트 표시
            if isPlaying {
                VStack {
                    Spacer()

                    Text("편안한 백색소음과 함께")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        .padding(.top, 200)
                }
            } else {
                VStack {
                    Spacer()

                    VStack(spacing: 12) {
                        Image(systemName: "flame")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.3))

                        Text("사운드를 재생하면\n캠프파이어가 켜집니다")
                            .font(.system(size: 15))
                            .foregroundColor(.white.opacity(0.5))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 100)
                }
            }
        }
        .onAppear {
            if isPlaying {
                startAnimation()
            }
        }
        .onChange(of: isPlaying) { newValue in
            if newValue {
                startAnimation()
            }
        }
    }

    private func startAnimation() {
        // 가장 앞 불꽃 (빠른 애니메이션)
        withAnimation(
            .easeInOut(duration: 1.2)
            .repeatForever(autoreverses: true)
        ) {
            flameScale1 = 1.15
            flameOpacity1 = 1.0
        }

        // 앞에서 두번째
        withAnimation(
            .easeInOut(duration: 1.8)
            .repeatForever(autoreverses: true)
        ) {
            flameScale2 = 1.25
            flameOpacity2 = 0.85
        }

        // 중간
        withAnimation(
            .easeInOut(duration: 2.2)
            .repeatForever(autoreverses: true)
        ) {
            flameScale3 = 1.35
            flameOpacity3 = 0.7
        }

        // 뒤에서 두번째
        withAnimation(
            .easeInOut(duration: 2.8)
            .repeatForever(autoreverses: true)
        ) {
            flameScale4 = 1.4
            flameOpacity4 = 0.5
        }

        // 가장 뒤
        withAnimation(
            .easeInOut(duration: 3.2)
            .repeatForever(autoreverses: true)
        ) {
            flameScale5 = 1.5
            flameOpacity5 = 0.35
        }

        // 빛 반사 효과
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            glowIntensity = 0.6
        }

        // 불꽃 파편 1
        withAnimation(
            .easeOut(duration: 2.5)
            .repeatForever(autoreverses: false)
        ) {
            sparkOffset1 = -60
            sparkOpacity1 = 0.0
        }
        withAnimation(
            .easeIn(duration: 0.3)
            .delay(0)
            .repeatForever(autoreverses: false)
        ) {
            sparkOpacity1 = 0.8
        }

        // 불꽃 파편 2 (약간 지연)
        withAnimation(
            .easeOut(duration: 3.0)
            .delay(1.2)
            .repeatForever(autoreverses: false)
        ) {
            sparkOffset2 = -70
            sparkOpacity2 = 0.0
        }
        withAnimation(
            .easeIn(duration: 0.4)
            .delay(1.2)
            .repeatForever(autoreverses: false)
        ) {
            sparkOpacity2 = 0.7
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}

// MARK: - Saved Sounds List View
struct SavedSoundsListView: View {
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""

    var body: some View {
        ZStack {
            // 배경
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.05, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.15, blue: 0.25)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if viewModel.customSounds.isEmpty {
                emptyStateView()
            } else {
                soundsListView()
            }
        }
        .navigationTitle("저장된 사운드")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("닫기") {
                    dismiss()
                }
                .foregroundColor(.white)
            }
        }
        .onAppear {
            viewModel.loadSound()
            print("📋 [SavedSoundsListView] 저장된 사운드 개수: \(viewModel.customSounds.count)")
        }
    }

    // MARK: - Empty State
    @ViewBuilder
    private func emptyStateView() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "music.note.list")
                .font(.system(size: 64))
                .foregroundColor(.white.opacity(0.3))

            VStack(spacing: 8) {
                Text("저장된 사운드가 없어요")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text("홈 탭에서 나만의 첫 사운드를 만들어보세요")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Sounds List
    @ViewBuilder
    private func soundsListView() -> some View {
        ScrollView {
            VStack(spacing: 16) {
                // 검색 바
                searchBar()

                // 사운드 그리드
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(filteredSounds) { sound in
                        SoundCardView(sound: sound)
                            .onTapGesture {
                                selectSound(sound)
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
            .padding(.top, 16)
        }
    }

    // MARK: - Search Bar
    @ViewBuilder
    private func searchBar() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.5))

            TextField("사운드 검색", text: $searchText)
                .foregroundColor(.white)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.1))
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Computed Properties
    private var filteredSounds: [CustomSound] {
        if searchText.isEmpty {
            return viewModel.customSounds
        } else {
            return viewModel.customSounds.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // MARK: - Actions
    private func selectSound(_ sound: CustomSound) {
        print("🎵 [SavedSoundsListView] 사운드 선택: \(sound.title)")
        viewModel.selectedSound = sound
        viewModel.play(with: sound)
        dismiss()
    }
}

// MARK: - Sound Card View
struct SoundCardView: View {
    let sound: CustomSound

    var body: some View {
        VStack(spacing: 0) {
            // 상단 컬러 영역
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: sound.color).opacity(0.8),
                                Color(hex: sound.color)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 100)

                // 카테고리 아이콘
                Image(sound.category.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white.opacity(0.9))
            }

            // 하단 정보 영역
            VStack(alignment: .leading, spacing: 8) {
                Text(sound.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Image(systemName: "waveform")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))

                    Text(sound.category.displayName)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.black.opacity(0.3))
        }
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

