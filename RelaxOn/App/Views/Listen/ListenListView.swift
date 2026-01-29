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
    @State private var isShowingTimer = false
    @StateObject private var timerManager = TimerManager(viewModel: CustomSoundViewModel())
    
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

                // 스마트 추천 캐러셀
                smartRecommendationsView()
                    .padding(.bottom, 16)

                // 캠프파이어 중앙 배치 (사운드 바 공간 확보)
                CampfireView(isPlaying: viewModel.isPlaying)
                    .frame(maxHeight: .infinity)
                    .padding(.bottom, 100) // 사운드 바 높이만큼 패딩

                // 하단 미니 플레이어 (선택된 사운드가 있거나 재생 중이면 표시)
                if viewModel.isPlaying || viewModel.selectedSound != nil {
                    miniPlayerView()
                } else {
                    emptyPlayerView()
                }
            }
        }

        .navigationDestination(isPresented: $isShowingEditView) {
            if let editing = editingSound {
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

        .navigationDestination(isPresented: $isShowingCreateModal) {
            SavedSoundsListView()
        }

        .navigationDestination(isPresented: $isShowingTimer) {
            TimerView(timerManager: timerManager, isShowingTimer: $isShowingTimer)
        }

        .onAppear {
            selectedFile = viewModel.lastSound
            viewModel.loadSound()
            timerManager.viewModel = viewModel
            timerManager.timerDidFinish = {
                // 타이머 종료 시 처리
                print("⏰ 타이머 종료")
            }
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
                    Text(L.Listen.noSavedSounds.localized)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(.TitleText))

                    Text(L.Listen.createFirstSound.localized)
                        .font(.system(size: 15))
                        .foregroundColor(Color(.Text).opacity(0.6))
                }

                Button(action: {
                    isShowingCreateModal = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 16))
                        Text(L.Listen.newSoundCreate.localized)
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

    // MARK: - Header View
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Text(L.Tab.listen.localized)
                .foregroundColor(.white)
                .font(.system(size: 28, weight: .bold))

            Spacer()

            // 저장된 사운드 목록 버튼
            Button(action: {
                isShowingCreateModal = true
            }) {
                Image(systemName: "music.note.list")
                    .font(.system(size: 24))
                    .foregroundColor(Color(.PrimaryPurple))
            }
            .padding(.trailing, 12)

            // 타이머 버튼
            Button(action: {
                isShowingTimer = true
            }) {
                ZStack {
                    if timerManager.textTimer != nil && timerManager.remainingSeconds > 0 {
                        // 타이머 활성화 중
                        ZStack {
                            Circle()
                                .fill(Color(.PrimaryPurple).opacity(0.2))
                                .frame(width: 40, height: 40)

                            Image(systemName: "timer")
                                .font(.system(size: 20))
                                .foregroundColor(Color(.PrimaryPurple))
                        }
                    } else {
                        // 타이머 비활성화
                        Image(systemName: "timer")
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    // MARK: - Smart Recommendations View
    @ViewBuilder
    private func smartRecommendationsView() -> some View {
        let recommendations = viewModel.getSmartRecommendations()

        if !recommendations.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                // 헤더
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)

                    Text(getRecommendationTitle())
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding(.horizontal, 24)

                // 가로 스크롤 카드
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(recommendations) { sound in
                            RecommendationCard(sound: sound)
                                .onTapGesture {
                                    viewModel.selectedSound = sound
                                    viewModel.play(with: sound)
                                }
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 8)
        }
    }

    private func getRecommendationTitle() -> String {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 6..<12:
            return L.Listen.recommendationMorning.localized
        case 12..<18:
            return L.Listen.recommendationFocus.localized
        case 18..<22:
            return L.Listen.recommendationEvening.localized
        default:
            return L.Listen.recommendationSleep.localized
        }
    }

    // MARK: - Mini Player View
    @ViewBuilder
    private func miniPlayerView() -> some View {
        HStack(spacing: 16) {
            // 앨범 아트 (작은 캠프파이어) - 탭하면 전체 플레이어 열기
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
            .onTapGesture {
                isShowingSheet = true
            }

            // 사운드 정보 - 탭하면 전체 플레이어 열기
            VStack(alignment: .leading, spacing: 4) {
                if let sound = viewModel.selectedSound {
                    Text(sound.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        Text(sound.category.displayName)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))

                        // 타이머 활성화 시 남은 시간 표시
                        if timerManager.textTimer != nil && timerManager.remainingSeconds > 0 {
                            Text("•")
                                .font(.system(size: 10))
                                .foregroundColor(.white.opacity(0.5))

                            HStack(spacing: 3) {
                                Image(systemName: "timer")
                                    .font(.system(size: 10))
                                Text(formatRemainingTime(timerManager.remainingSeconds))
                                    .font(.system(size: 11, weight: .medium))
                            }
                            .foregroundColor(Color(.PrimaryPurple))
                        }
                    }
                }
            }
            .onTapGesture {
                isShowingSheet = true
            }

            Spacer()
                .onTapGesture {
                    isShowingSheet = true
                }

            // 재생/일시정지 버튼 (독립된 버튼 - 전체 플레이어 열지 않음)
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
            .buttonStyle(PlainButtonStyle())
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
        .navigationDestination(isPresented: $isShowingSheet) {
            SoundPlayerFullModalView()
        }
    }

    // MARK: - Helper Functions
    private func formatRemainingTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60

        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
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

                    Text(L.Listen.selectSoundToPlay.localized)
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

                    Text(L.Listen.relaxWithWhiteNoise.localized)
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

                        Text(L.Listen.playSoundForCampfire.localized)
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

// MARK: - Timer View

struct TimerView: View {
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @ObservedObject var timerManager: TimerManager
    @Binding var isShowingTimer: Bool
    @State private var hours: [Int] = Array(0...23)
    @State private var minutes: [Int] = Array(0...59)
    @State private var isTimerRunning = false

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

            VStack(spacing: 0) {
                if isTimerRunning {
                    // 타이머 실행 중
                    timerProgressView()
                } else {
                    // 타이머 설정
                    timerSettingView()
                }
            }
        }
        .navigationTitle(L.Timer.sleepTimer.localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isTimerRunning = timerManager.textTimer != nil && timerManager.remainingSeconds > 0
        }
    }

    // MARK: - Timer Setting View
    @ViewBuilder
    private func timerSettingView() -> some View {
        VStack(spacing: 40) {
            Spacer()

            // 타이머 아이콘
            ZStack {
                Circle()
                    .fill(Color(.PrimaryPurple).opacity(0.2))
                    .frame(width: 120, height: 120)

                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 60))
                    .foregroundColor(Color(.PrimaryPurple))
            }

            VStack(spacing: 12) {
                Text(L.Timer.forGoodSleep.localized)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)

                Text(L.Timer.autoStopDescription.localized)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()

            // 시간 선택
            TimePickerView(
                hours: $hours,
                minutes: $minutes,
                selectedTimeIndexHours: $timerManager.selectedTimeIndexHours,
                selectedTimeIndexMinutes: $timerManager.selectedTimeIndexMinutes
            )

            Spacer()

            // 시작 버튼
            Button(action: {
                if let sound = viewModel.selectedSound {
                    viewModel.play(with: sound)
                }
                timerManager.startTimer(timerManager: timerManager)
                withAnimation {
                    isTimerRunning = true
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 18))
                    Text(L.Timer.startTimer.localized)
                        .font(.system(size: 17, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.PrimaryPurple),
                            Color(.PrimaryPurple).opacity(0.8)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(color: Color(.PrimaryPurple).opacity(0.4), radius: 12, x: 0, y: 6)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Timer Progress View
    @ViewBuilder
    private func timerProgressView() -> some View {
        VStack(spacing: 40) {
            Spacer()

            // 원형 프로그레스 바
            ZStack {
                timerManager.getCircularProgressBar()
                    .frame(width: 280, height: 280)

                VStack(spacing: 12) {
                    timerManager.getTimeText()
                        .foregroundColor(.white)

                    Text(L.Timer.remainingTime.localized)
                        .font(.system(size: 15))
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Spacer()

            // 컨트롤 버튼들
            HStack(spacing: 20) {
                // 중지 버튼
                Button(action: {
                    timerManager.stopTimer(timerManager: timerManager)
                    withAnimation {
                        isTimerRunning = false
                    }
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 70, height: 70)

                            Image(systemName: "stop.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }

                        Text(L.Timer.stop.localized)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                Spacer()

                // 일시정지/재개 버튼
                Button(action: {
                    if let timer = timerManager.textTimer, timer.isValid {
                        timerManager.pauseTimer(timerManager: timerManager)
                    } else {
                        timerManager.resumeTimer(timerManager: timerManager)
                        if let sound = viewModel.selectedSound {
                            viewModel.play(with: sound)
                        }
                    }
                }) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(.PrimaryPurple))
                                .frame(width: 90, height: 90)
                                .shadow(color: Color(.PrimaryPurple).opacity(0.4), radius: 12, x: 0, y: 6)

                            if let timer = timerManager.textTimer, timer.isValid {
                                Image(systemName: "pause.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.white)
                            }
                        }

                        Text(timerManager.textTimer?.isValid == true ? L.Timer.pause.localized : L.Timer.resume.localized)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding(.horizontal, 60)
            .padding(.bottom, 60)
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
    @EnvironmentObject var subscriptionManager: SubscriptionManager
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @State private var showCreateView = false
    @State private var showSubscription = false

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
        .navigationTitle(L.Listen.savedSounds.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 8) {
                    // 무료 유저 사운드 카운트 표시
                    if !subscriptionManager.isPremium {
                        let userCount = viewModel.customSounds.filter { !$0.isPreset }.count
                        Text("\(userCount)/\(SubscriptionManager.freeMaxCustomSounds)")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(userCount >= SubscriptionManager.freeMaxCustomSounds ? .orange : Color(.PrimaryPurple))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.PrimaryPurple).opacity(0.15))
                            .cornerRadius(8)
                    }

                    Button {
                        let userCount = viewModel.customSounds.filter { !$0.isPreset }.count
                        if subscriptionManager.canCreateMoreSounds(currentCount: userCount) {
                            showCreateView = true
                        } else {
                            showSubscription = true
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18))
                            Text(L.SoundList.createNew.localized)
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(Color(.PrimaryPurple))
                    }
                }
            }
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
                .environmentObject(subscriptionManager)
        }
        .navigationDestination(isPresented: $showCreateView) {
            CreateNewSoundView()
                .environmentObject(viewModel)
                .onDisappear {
                    viewModel.loadSound()
                    print("🔄 [SavedSoundsListView] 리스트 새로고침 - 저장된 사운드 개수: \(viewModel.customSounds.count)")
                }
        }
        .onAppear {
            viewModel.loadSound()
            viewModel.loadPresetSounds() // 프리셋 사운드 로드
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
                Text(L.Listen.noSavedSounds.localized)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Text(L.Listen.createFirstSound.localized)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }

            Button(action: {
                showCreateView = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 16))
                    Text(L.Listen.newSoundCreate.localized)
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
    }

    // MARK: - Sounds List
    @ViewBuilder
    private func soundsListView() -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // 검색 바
                searchBar()

                // 프리셋 섹션 (카테고리별)
                if searchText.isEmpty && !viewModel.presetSounds.isEmpty {
                    presetSectionsView()
                }

                // 내가 만든 사운드 섹션
                if !myCreatedSounds.isEmpty {
                    myCreatedSoundsSection()
                }

                // 검색 결과 (검색 중일 때)
                if !searchText.isEmpty {
                    searchResultsSection()
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }

    // MARK: - Preset Sections by Category
    @ViewBuilder
    private func presetSectionsView() -> some View {
        let groupedPresets = Dictionary(grouping: viewModel.presetSounds) { preset in
            PresetSound.allPresets.first(where: { $0.localizedName == preset.title })?.category ?? .sleep
        }

        ForEach(PresetCategory.allCases, id: \.self) { category in
            if let presets = groupedPresets[category], !presets.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    // 카테고리 헤더
                    HStack(spacing: 8) {
                        Image(systemName: category.icon)
                            .font(.system(size: 18))
                            .foregroundColor(category.color)

                        Text(category.displayName)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding(.horizontal, 20)

                    // 프리셋 그리드
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(presets) { sound in
                            SoundCardView(sound: sound, viewModel: viewModel)
                                .onTapGesture {
                                    selectSound(sound)
                                }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }

    // MARK: - My Created Sounds Section
    @ViewBuilder
    private func myCreatedSoundsSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 섹션 헤더
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(.PrimaryPurple))

                Text(L.Listen.mySounds.localized)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                Text("\(myCreatedSounds.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(.PrimaryPurple))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.PrimaryPurple).opacity(0.2))
                    .cornerRadius(8)

                Spacer()
            }
            .padding(.horizontal, 20)

            // 사운드 그리드
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(myCreatedSounds) { sound in
                    SoundCardView(sound: sound, viewModel: viewModel)
                        .onTapGesture {
                            selectSound(sound)
                        }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Search Results Section
    @ViewBuilder
    private func searchResultsSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 검색 결과 헤더
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.6))

                Text(L.Listen.searchResults.localized)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)

                Text("\(filteredSounds.count)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)

                Spacer()
            }
            .padding(.horizontal, 20)

            if filteredSounds.isEmpty {
                // 검색 결과 없음
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.3))

                    Text(L.Listen.noSearchResults.localized)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                // 검색 결과 그리드
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(filteredSounds) { sound in
                        SoundCardView(sound: sound, viewModel: viewModel)
                            .onTapGesture {
                                selectSound(sound)
                            }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    // MARK: - Search Bar
    @ViewBuilder
    private func searchBar() -> some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.5))

            TextField(L.Listen.soundSearch.localized, text: $searchText)
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

    /// 사용자가 직접 만든 사운드 (프리셋 제외)
    private var myCreatedSounds: [CustomSound] {
        viewModel.customSounds.filter { !$0.isPreset }
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
    var viewModel: CustomSoundViewModel? = nil

    var body: some View {
        VStack(spacing: 0) {
            // 상단 썸네일 영역
            ZStack {
                // 레이어 사운드면 썸네일, 아니면 기존 배경
                if sound.isLayeredSound {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(height: 100)

                    SoundThumbnailView(sound: sound, size: 60)
                } else {
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

                // 즐겨찾기 하트 아이콘 (우측 상단)
                if let vm = viewModel {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                vm.toggleFavorite(sound)
                            }) {
                                Image(systemName: sound.isFavorite ? "heart.fill" : "heart")
                                    .font(.system(size: 18))
                                    .foregroundColor(sound.isFavorite ? .red : .white.opacity(0.8))
                                    .padding(8)
                                    .background(Color.black.opacity(0.3))
                                    .clipShape(Circle())
                            }
                            .padding(8)
                        }
                        Spacer()
                    }
                }

                // 프리셋 배지 (좌측 상단)
                if sound.isPreset {
                    VStack {
                        HStack {
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                Text(L.Listen.presets.localized)
                                    .font(.system(size: 10, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.PrimaryPurple).opacity(0.9))
                            .cornerRadius(8)
                            .padding(8)

                            Spacer()
                        }
                        Spacer()
                    }
                }
            }

            // 하단 정보 영역
            VStack(alignment: .leading, spacing: 8) {
                Text(sound.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    // 레이어 개수 또는 카테고리 표시
                    if let layers = sound.soundLayers, layers.count > 1 {
                        Image(systemName: "square.3.layers.3d")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))

                        Text(String(format: L.Listen.layerCount.localized, layers.count))
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    } else {
                        Image(systemName: "waveform")
                            .font(.system(size: 10))
                            .foregroundColor(.white.opacity(0.6))

                        Text(sound.category.displayName)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.6))
                    }
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

// MARK: - Recommendation Card View
struct RecommendationCard: View {
    let sound: CustomSound

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 상단 아이콘 영역
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: sound.color).opacity(0.6),
                                Color(hex: sound.color)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)

                if sound.isLayeredSound {
                    SoundThumbnailView(sound: sound, size: 35)
                } else {
                    Image(sound.category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                }

                // 추천 배지
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "sparkles")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                            .padding(6)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .frame(width: 60, height: 60)
            }

            // 사운드 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(sound.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 4) {
                    Image(systemName: "waveform")
                        .font(.system(size: 9))
                    Text(sound.category.displayName)
                        .font(.system(size: 11))
                }
                .foregroundColor(.white.opacity(0.6))
            }
        }
        .frame(width: 140)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
    }
}

