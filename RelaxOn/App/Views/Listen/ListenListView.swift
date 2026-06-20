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
    @State private var orbPressed = false
    // 오브 스와이프(다음 소리) — 손가락 따라 3D로 굴러가는 느낌
    @State private var orbCommitted: Double = 0   // 확정된 회전(전환 시 ±360 누적)
    @State private var orbDragAngle: Double = 0   // 드래그 중 실시간 회전
    @State private var showNameLabel = false
    @State private var nameLabelText = ""
    @State private var nameToken = 0
    @AppStorage("didShowSwipeHint") private var didShowSwipeHint = false
    @StateObject private var timerManager = TimerManager(viewModel: CustomSoundViewModel())
    
    // MARK: - Body
    var body: some View {
        // 가장 단순한 첫 화면: 화면 가운데의 큰 "재생/일시정지" 버튼 하나.
        // 제목·추천·떠다니는 미니 플레이어 없음. 시각장애인은 큰 버튼 하나만 두 번 탭하면 된다.
        let timerActive = timerManager.textTimer != nil && timerManager.remainingSeconds > 0
        ZStack {
            ScreenBackground()

            VStack(spacing: 0) {
                Spacer()

                // 메인 오브: 탭=재생/일시정지, 좌우 스와이프=다음 배경음
                VStack(spacing: DS.Spacing.md) {
                    CampfireView(isPlaying: viewModel.isPlaying,
                                 tint: orbTint,
                                 roll: orbCommitted + orbDragAngle)
                        .scaleEffect(orbPressed ? 0.97 : 1.0)
                        .contentShape(Circle())
                        .animation(.easeInOut(duration: 0.6), value: orbTint) // 색 전환 부드럽게
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    orbPressed = true
                                    // 드래그를 따라 실시간 회전 (가장자리에서 너무 넘어가지 않게 제한)
                                    orbDragAngle = max(-85, min(85, Double(value.translation.width) * 0.55))
                                }
                                .onEnded { value in
                                    let dx = value.translation.width
                                    let dist = hypot(value.translation.width, value.translation.height)
                                    if abs(dx) > 50 {
                                        // 그 방향으로 한 바퀴 굴러서 다음 곡으로 전환
                                        let dir: Double = dx < 0 ? -1 : 1
                                        withAnimation(.easeOut(duration: 0.6)) {
                                            orbCommitted += dir * 360
                                            orbDragAngle = 0
                                            orbPressed = false
                                        }
                                        nextSound()
                                    } else if dist < 12 {
                                        // 탭 → 재생/일시정지
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                            orbDragAngle = 0
                                            orbPressed = false
                                        }
                                        togglePlay()
                                    } else {
                                        // 살짝만 밀었으면 도로 제자리
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            orbDragAngle = 0
                                            orbPressed = false
                                        }
                                    }
                                }
                        )
                        .accessibilityElement()
                        .accessibilityLabel(viewModel.isPlaying ? L.A11y.pause.localized : L.A11y.play.localized)
                        .accessibilityValue(currentSoundTitle)
                        .accessibilityAddTraits(.isButton)
                        .accessibilityAction(named: Text(L.A11y.nextSound.localized)) { nextSound() }

                    // 소리 이름 / 첫 사용 힌트 (잠깐만 표시)
                    Text(nameLabelText)
                        .font(DS.Font.callout())
                        .foregroundColor(DS.Colors.textSecondary)
                        .lineLimit(1)
                        .opacity(showNameLabel ? 1 : 0)
                        .frame(height: 22)
                        .accessibilityHidden(true)
                }

                Spacer()

                // 하단 보조 버튼 (소리 선택 / 타이머) — 리퀴드 글래스
                HStack(spacing: DS.Spacing.lg) {
                    GlassIconButton(systemName: "music.note.list") {
                        isShowingCreateModal = true
                    }
                    .accessibilityLabel(L.A11y.savedSoundsButton.localized)

                    GlassIconButton(systemName: "timer", active: timerActive) {
                        isShowingTimer = true
                    }
                    .accessibilityLabel(L.A11y.timerButton.localized)
                    .accessibilityValue(timerActive
                        ? String(format: L.A11y.timerActiveValue.localized, formatRemainingTime(timerManager.remainingSeconds))
                        : "")
                }
                .padding(.bottom, DS.Spacing.xxl)
            }
            .dsConstrainedWidth()
        }
        .navigationBarHidden(true)

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
            viewModel.loadSound()
            viewModel.loadPresetSounds() // 첫 설치 시 기본 소리(프리셋) 제공
            // 선택된 소리가 없으면 기본 프리셋을 재생 대상으로 지정 → 큰 재생 버튼이 바로 재생 가능
            if viewModel.selectedSound == nil, let firstPreset = viewModel.presetSounds.first {
                viewModel.selectedSound = firstPreset
                viewModel.lastSound = firstPreset
            }
            selectedFile = viewModel.lastSound
            timerManager.viewModel = viewModel
            timerManager.timerDidFinish = {
                // 타이머 종료 시 처리
                print("⏰ 타이머 종료")
            }

            // 처음 한 번: 옆으로 넘기면 소리가 바뀐다는 힌트
            if !didShowSwipeHint {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    flashLabel(L.Listen.swipeHint.localized, duration: 3.5)
                    didShowSwipeHint = true
                }
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
        let timerActive = timerManager.textTimer != nil && timerManager.remainingSeconds > 0
        HStack(spacing: DS.Spacing.sm) {
            Text(L.Tab.listen.localized)
                .font(DS.Font.largeTitle())
                .foregroundColor(DS.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Spacer(minLength: DS.Spacing.xs)

            // 저장된 사운드 목록 버튼
            CircleIconButton(systemName: "music.note.list") {
                isShowingCreateModal = true
            }
            .accessibilityLabel(L.A11y.savedSoundsButton.localized)

            // 타이머 버튼
            CircleIconButton(systemName: "timer", active: timerActive) {
                isShowingTimer = true
            }
            .accessibilityLabel(L.A11y.timerButton.localized)
            .accessibilityValue(
                timerActive
                ? String(format: L.A11y.timerActiveValue.localized, formatRemainingTime(timerManager.remainingSeconds))
                : ""
            )
        }
        .padding(.horizontal, DS.Spacing.screen)
        .padding(.top, DS.Spacing.xs)
        .padding(.bottom, DS.Spacing.md)
    }

    // MARK: - Smart Recommendations View
    @ViewBuilder
    private func smartRecommendationsView() -> some View {
        let recommendations = viewModel.getSmartRecommendations()

        if !recommendations.isEmpty {
            VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                // 헤더
                SectionHeader(title: getRecommendationTitle(), systemIcon: "sparkles")
                    .padding(.horizontal, DS.Spacing.screen)

                // 가로 스크롤 카드
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: DS.Spacing.sm) {
                        ForEach(recommendations) { sound in
                            RecommendationCard(sound: sound)
                                .onTapGesture {
                                    viewModel.selectedSound = sound
                                    viewModel.play(with: sound)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityAddTraits(.isButton)
                                .accessibilityHint(L.A11y.playSoundHint.localized)
                        }
                    }
                    .padding(.horizontal, DS.Spacing.screen)
                }
            }
            .padding(.vertical, DS.Spacing.xs)
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

    // MARK: - Play Button
    /// 메인 버튼: 재생 중이면 멈추고, 아니면 (선택된 소리 또는 마지막 소리를) 재생
    private func togglePlay() {
        if viewModel.isPlaying {
            viewModel.stopSound()
        } else {
            let sound = viewModel.selectedSound ?? viewModel.lastSound
            viewModel.selectedSound = sound
            viewModel.play(with: sound)
        }
    }

    /// 현재(또는 마지막) 소리 제목
    private var currentSoundTitle: String {
        (viewModel.selectedSound ?? viewModel.lastSound).title
    }

    /// 비슷한 채도의 차분한 색 팔레트 (소리/분위기마다 다른 색)
    private static let orbPalette: [Color] = [
        Color(hex: "6F6AD6"), // 라벤더
        Color(hex: "4FA2C4"), // 청록
        Color(hex: "5DAE84"), // 세이지
        Color(hex: "C77BA8"), // 모브 로즈
        Color(hex: "D2A158"), // 머스타드
        Color(hex: "6580C0"), // 슬레이트 블루
        Color(hex: "A579CE"), // 라일락
        Color(hex: "DA8A78")  // 코랄
    ]

    /// 현재 소리에 대응하는 오브 색 (목록 위치 기반 → 곡마다 일관)
    private var orbTint: Color {
        let pool = viewModel.customSounds
        guard !pool.isEmpty,
              let idx = pool.firstIndex(where: { $0.id == viewModel.selectedSound?.id }) else {
            return DS.Colors.accent
        }
        return Self.orbPalette[idx % Self.orbPalette.count]
    }

    /// 다음 배경음으로 전환 (마지막이면 처음으로 순환). 재생 중이 아니면 자동 재생.
    private func nextSound() {
        let pool = viewModel.customSounds
        guard !pool.isEmpty else { return }
        let idx = pool.firstIndex(where: { $0.id == viewModel.selectedSound?.id }) ?? -1
        let next = pool[(idx + 1) % pool.count]
        let wasPlaying = viewModel.isPlaying
        viewModel.selectedSound = next
        // 재생 중이었으면 다음 곡을 이어서 재생, 멈춰있었으면 선택만 바꿈
        if wasPlaying {
            viewModel.play(with: next) // 페이드 인으로 부드럽게
        }
        flashLabel(next.title)
    }

    /// 라벨(소리 이름/힌트)을 잠깐 보여주고 사라지게
    private func flashLabel(_ text: String, duration: Double = 1.8) {
        nameLabelText = text
        nameToken += 1
        let token = nameToken
        withAnimation(.easeInOut(duration: 0.35)) { showNameLabel = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if token == nameToken {
                withAnimation(.easeInOut(duration: 0.5)) { showNameLabel = false }
            }
        }
    }

    // MARK: - Mini Player View
    @ViewBuilder
    private func miniPlayerView() -> some View {
        HStack(spacing: 16) {
            // 정보 영역(앨범 아트 + 제목/카테고리)을 하나의 접근성 요소로 묶어
            // "전체 플레이어 열기" 버튼으로 노출
            HStack(spacing: DS.Spacing.md) {
                // 앨범 아트 (부드러운 오브) - 장식용
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [DS.Colors.accent.opacity(0.85), DS.Colors.accent.opacity(0.55)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 46, height: 46)

                    Image(systemName: viewModel.isPlaying ? "waveform" : "moon.stars.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .accessibilityHidden(true) // 장식용 아이콘

                // 사운드 정보
                VStack(alignment: .leading, spacing: 3) {
                    if let sound = viewModel.selectedSound {
                        Text(sound.title)
                            .font(DS.Font.headline())
                            .foregroundColor(DS.Colors.textPrimary)
                            .lineLimit(1)

                        HStack(spacing: DS.Spacing.xs) {
                            Text(sound.category.displayName)
                                .font(DS.Font.caption())
                                .foregroundColor(DS.Colors.textSecondary)

                            // 타이머 활성화 시 남은 시간 표시
                            if timerManager.textTimer != nil && timerManager.remainingSeconds > 0 {
                                Text("•")
                                    .font(DS.Font.caption())
                                    .foregroundColor(DS.Colors.textTertiary)

                                HStack(spacing: 3) {
                                    Image(systemName: "timer")
                                        .font(.system(size: 10))
                                    Text(formatRemainingTime(timerManager.remainingSeconds))
                                        .font(DS.Font.caption().weight(.medium))
                                }
                                .foregroundColor(DS.Colors.accent)
                            }
                        }
                    }
                }

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isShowingSheet = true
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isButton)
            .accessibilityHint(L.A11y.openFullPlayerHint.localized)

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
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 48, height: 48)
                    .background(Circle().fill(DS.Colors.accent))
            }
            .buttonStyle(PlainButtonStyle())
            .accessibilityLabel(viewModel.isPlaying ? L.A11y.pause.localized : L.A11y.play.localized)
        }
        .padding(.horizontal, DS.Spacing.md)
        .padding(.vertical, DS.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous)
                .fill(DS.Colors.surface)
                .shadow(color: DS.Shadow.floating.color, radius: DS.Shadow.floating.radius, x: 0, y: DS.Shadow.floating.y)
        )
        .padding(.horizontal, DS.Spacing.md)
        .padding(.bottom, DS.Spacing.lg)
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
            HStack(spacing: DS.Spacing.sm) {
                Image(systemName: "music.note")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(DS.Colors.accent)
                    .accessibilityHidden(true)

                Text(L.Listen.selectSoundToPlay.localized)
                    .font(DS.Font.callout())
                    .foregroundColor(DS.Colors.textSecondary)

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(DS.Colors.textTertiary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, DS.Spacing.lg)
            .padding(.vertical, DS.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.lg, style: .continuous)
                    .fill(DS.Colors.surface)
                    .shadow(color: DS.Shadow.card.color, radius: DS.Shadow.card.radius, x: 0, y: DS.Shadow.card.y)
            )
            .padding(.horizontal, DS.Spacing.md)
            .padding(.bottom, DS.Spacing.lg)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Campfire View

struct CampfireView: View {
    let isPlaying: Bool
    var tint: Color = DS.Colors.accent
    var roll: Double = 0   // 표면 회전 각도(도) — 윤곽은 원형 유지, 표면만 굴러감

    @State private var breathe = false
    @State private var glow = false

    private var rollRad: Double { roll * .pi / 180 }
    /// 앞면 가시성 (0°=정면 1, 90°=옆모서리 0, 뒷면 0)
    private var frontFacing: Double { max(0, cos(rollRad)) }
    /// 표면 가로 압축(모서리에서 납작) + 가로 이동량
    private var surfaceSquashX: CGFloat { CGFloat(max(0.1, abs(cos(rollRad)))) }
    private var surfaceTravel: CGFloat { CGFloat(sin(rollRad)) }

    var body: some View {
        ZStack {
            // 부드러운 외곽 글로우 (윤곽 고정)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [tint.opacity(isPlaying ? 0.35 : 0.16), .clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: 220
                    )
                )
                .frame(width: 300, height: 300)
                .scaleEffect(glow ? 1.05 : 0.9)
                .blur(radius: 30)

            // 솔리드 구체 — 윤곽은 항상 원형, 표면(반사·아이콘)만 굴러감
            Circle()
                .fill(
                    LinearGradient(
                        colors: [tint.opacity(0.95), tint.opacity(0.55)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 220, height: 220)
                .overlay(
                    // 고정 스펙큘러 하이라이트 (광원은 고정)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.white.opacity(0.32), .clear],
                                center: UnitPoint(x: 0.3, y: 0.26),
                                startRadius: 4,
                                endRadius: 140
                            )
                        )
                )
                .overlay(
                    // 표면 위 부드러운 반사 — 굴러가면 같이 이동/소멸
                    Circle()
                        .fill(Color.white.opacity(0.22))
                        .frame(width: 64, height: 64)
                        .blur(radius: 16)
                        .scaleEffect(x: surfaceSquashX, y: 1, anchor: .center)
                        .offset(x: surfaceTravel * 66, y: -8)
                        .opacity(frontFacing)
                )
                .overlay(
                    // 표면 위 아이콘 — 앞면에서만 보이고 굴러서 뒤로 사라졌다 돌아옴
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 72, weight: .medium))
                        .foregroundColor(.white)
                        .scaleEffect(x: surfaceSquashX, y: 1, anchor: .center)
                        .offset(x: surfaceTravel * 60 + (isPlaying ? 0 : 6))
                        .opacity(frontFacing)
                )
                .clipShape(Circle())   // ← 표면이 굴러도 윤곽은 항상 원형
                .scaleEffect(breathe ? 1.04 : 0.97)
                .shadow(color: tint.opacity(0.45), radius: 40, x: 0, y: 14)
        }
        .frame(width: 240, height: 240)
        .onAppear { startBreathing() }
        .onChange(of: isPlaying) { _ in startBreathing() }
    }

    private func startBreathing() {
        let duration: Double = isPlaying ? 3.2 : 4.5
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
            breathe = true
        }
        withAnimation(.easeInOut(duration: duration * 1.3).repeatForever(autoreverses: true)) {
            glow = true
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
            ScreenBackground()

            VStack(spacing: 0) {
                if isTimerRunning {
                    // 타이머 실행 중
                    timerProgressView()
                } else {
                    // 타이머 설정
                    timerSettingView()
                }
            }
            .dsConstrainedWidth()
        }
        .navigationTitle(L.Timer.sleepTimer.localized)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isTimerRunning = timerManager.textTimer != nil && timerManager.remainingSeconds > 0
        }
    }

    // 남은 시간을 VoiceOver용 문자열로 변환
    private func formatRemainingTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = seconds % 60
        if hours > 0 {
            return "\(hours)\(L.Timer.hour.localized) \(minutes)\(L.Timer.minute.localized)"
        } else if minutes > 0 {
            return "\(minutes)\(L.Timer.minute.localized) \(secs)\(L.Timer.second.localized)"
        } else {
            return "\(secs)\(L.Timer.second.localized)"
        }
    }

    // MARK: - Timer Setting View
    @ViewBuilder
    private func timerSettingView() -> some View {
        VStack(spacing: DS.Spacing.xxl) {
            Spacer()

            // 타이머 아이콘
            ZStack {
                Circle()
                    .fill(DS.Colors.accentSoft)
                    .frame(width: 120, height: 120)

                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 52, weight: .light))
                    .foregroundColor(DS.Colors.accent)
            }
            .accessibilityHidden(true)

            VStack(spacing: DS.Spacing.xs) {
                Text(L.Timer.forGoodSleep.localized)
                    .font(DS.Font.title())
                    .foregroundColor(DS.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                Text(L.Timer.autoStopDescription.localized)
                    .font(DS.Font.callout())
                    .foregroundColor(DS.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.8)
            }
            .padding(.horizontal, DS.Spacing.xl)

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
            Button {
                if let sound = viewModel.selectedSound {
                    viewModel.play(with: sound)
                }
                timerManager.startTimer(timerManager: timerManager)
                withAnimation {
                    isTimerRunning = true
                }
            } label: {
                HStack(spacing: DS.Spacing.xs) {
                    Image(systemName: "play.fill")
                    Text(L.Timer.startTimer.localized)
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.horizontal, DS.Spacing.xxl)
            .padding(.bottom, DS.Spacing.xxl)
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
                    .accessibilityHidden(true)

                VStack(spacing: DS.Spacing.xs) {
                    timerManager.getTimeText()
                        .foregroundColor(DS.Colors.textPrimary)

                    Text(L.Timer.remainingTime.localized)
                        .font(DS.Font.callout())
                        .foregroundColor(DS.Colors.textSecondary)
                }
                // 남은 시간을 하나의 요소로 묶고, 값이 바뀔 때마다 VoiceOver가 갱신
                .accessibilityElement(children: .combine)
                .accessibilityLabel(L.A11y.remainingTimeLabel.localized)
                .accessibilityValue(formatRemainingTime(timerManager.remainingSeconds))
                .accessibilityAddTraits(.updatesFrequently)
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
                    VStack(spacing: DS.Spacing.xs) {
                        ZStack {
                            Circle()
                                .fill(DS.Colors.surfaceSunken)
                                .frame(width: 70, height: 70)

                            Image(systemName: "stop.fill")
                                .font(.system(size: 24))
                                .foregroundColor(DS.Colors.textSecondary)
                        }

                        Text(L.Timer.stop.localized)
                            .font(DS.Font.caption())
                            .foregroundColor(DS.Colors.textSecondary)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(L.Timer.stop.localized)

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
                    VStack(spacing: DS.Spacing.xs) {
                        ZStack {
                            Circle()
                                .fill(DS.Colors.accent)
                                .frame(width: 90, height: 90)
                                .shadow(color: DS.Colors.accent.opacity(0.4), radius: 16, x: 0, y: 8)

                            Image(systemName: timerManager.textTimer?.isValid == true ? "pause.fill" : "play.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }

                        Text(timerManager.textTimer?.isValid == true ? L.Timer.pause.localized : L.Timer.resume.localized)
                            .font(DS.Font.caption())
                            .foregroundColor(DS.Colors.textSecondary)
                    }
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(timerManager.textTimer?.isValid == true ? L.Timer.pause.localized : L.Timer.resume.localized)
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
    @State private var editingSound: CustomSound? = nil
    @State private var showEditView = false

    var body: some View {
        ZStack {
            ScreenBackground()

            if viewModel.customSounds.isEmpty {
                emptyStateView()
            } else {
                soundsListView()
            }
        }
        .navigationTitle(L.Listen.savedSounds.localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 제목이 잘리지 않도록 우측에는 컴팩트한 '+' 버튼 하나만 둔다.
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let userCount = viewModel.customSounds.filter { !$0.isPreset }.count
                    if subscriptionManager.canCreateMoreSounds(currentCount: userCount) {
                        showCreateView = true
                    } else {
                        showSubscription = true
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(DS.Colors.accent)
                }
                .accessibilityLabel(L.A11y.createNewButton.localized)
            }
        }
        .sheet(isPresented: $showSubscription) {
            SubscriptionView()
                .environmentObject(subscriptionManager)
        }
        .navigationDestination(isPresented: $showCreateView) {
            SoundStudioView()
                .environmentObject(viewModel)
                .onDisappear {
                    viewModel.loadSound()
                    print("🔄 [SavedSoundsListView] 리스트 새로고침 - 저장된 사운드 개수: \(viewModel.customSounds.count)")
                }
        }
        .navigationDestination(isPresented: $showEditView) {
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
                .environmentObject(viewModel)
                .onDisappear { viewModel.loadSound() }
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
        VStack(spacing: DS.Spacing.xl) {
            Image(systemName: "music.note.list")
                .font(.system(size: 56, weight: .light))
                .foregroundColor(DS.Colors.accent.opacity(0.5))
                .accessibilityHidden(true)

            VStack(spacing: DS.Spacing.xs) {
                Text(L.Listen.noSavedSounds.localized)
                    .font(DS.Font.title())
                    .foregroundColor(DS.Colors.textPrimary)

                Text(L.Listen.createFirstSound.localized)
                    .font(DS.Font.callout())
                    .foregroundColor(DS.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                showCreateView = true
            } label: {
                HStack(spacing: DS.Spacing.xs) {
                    Image(systemName: "plus.circle.fill")
                    Text(L.Listen.newSoundCreate.localized)
                }
            }
            .buttonStyle(PrimaryButtonStyle(fullWidth: false))
            .padding(.top, DS.Spacing.xs)
        }
        .padding(.horizontal, DS.Spacing.xxl)
    }

    // MARK: - Sounds List
    @ViewBuilder
    private func soundsListView() -> some View {
        ScrollView {
            VStack(spacing: DS.Spacing.xl) {
                // 무료 사용자 사운드 개수 표시 (네비게이션 바 대신 콘텐츠 안에)
                if !subscriptionManager.isPremium {
                    let userCount = viewModel.customSounds.filter { !$0.isPreset }.count
                    let reached = userCount >= SubscriptionManager.freeMaxCustomSounds
                    HStack(spacing: DS.Spacing.xxs) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 11, weight: .semibold))
                        Text(String(format: L.SoundList.freeCount.localized, userCount, SubscriptionManager.freeMaxCustomSounds))
                            .font(DS.Font.caption().weight(.semibold))
                        Spacer()
                    }
                    .foregroundColor(reached ? DS.Colors.warm : DS.Colors.textSecondary)
                    .padding(.horizontal, DS.Spacing.screen)
                }

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
            .padding(.top, DS.Spacing.md)
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
                VStack(alignment: .leading, spacing: DS.Spacing.sm) {
                    // 카테고리 헤더
                    SectionHeader(title: category.displayName, systemIcon: category.icon)
                        .padding(.horizontal, DS.Spacing.screen)

                    // 프리셋 그리드
                    LazyVGrid(columns: DS.Layout.grid(), spacing: DS.Spacing.md) {
                        ForEach(presets) { sound in
                            SoundCardView(sound: sound, viewModel: viewModel)
                                .onTapGesture {
                                    selectSound(sound)
                                }
                        }
                    }
                    .padding(.horizontal, DS.Spacing.screen)
                }
            }
        }
    }

    // MARK: - My Created Sounds Section
    @ViewBuilder
    private func myCreatedSoundsSection() -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            // 섹션 헤더
            SectionHeader(title: L.Listen.mySounds.localized,
                          systemIcon: "person.fill",
                          accessory: "\(myCreatedSounds.count)")
                .padding(.horizontal, DS.Spacing.screen)

            // 사운드 그리드
            LazyVGrid(columns: DS.Layout.grid(), spacing: DS.Spacing.md) {
                ForEach(myCreatedSounds) { sound in
                    SoundCardView(sound: sound, viewModel: viewModel)
                        .onTapGesture {
                            selectSound(sound)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(soundCardAccessibilityLabel(sound))
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint(L.A11y.playSoundHint.localized)
                        .accessibilityAction(named: Text(L.Common.edit.localized)) { startEdit(sound) }
                        .accessibilityAction(named: Text(L.Common.delete.localized)) { deleteSound(sound) }
                        .contextMenu { cardContextMenu(for: sound) }
                }
            }
            .padding(.horizontal, DS.Spacing.screen)
        }
    }

    // MARK: - Search Results Section
    @ViewBuilder
    private func searchResultsSection() -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            // 검색 결과 헤더
            SectionHeader(title: L.Listen.searchResults.localized,
                          systemIcon: "magnifyingglass",
                          accessory: "\(filteredSounds.count)")
                .padding(.horizontal, DS.Spacing.screen)

            if filteredSounds.isEmpty {
                // 검색 결과 없음
                VStack(spacing: DS.Spacing.sm) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(DS.Colors.textTertiary)

                    Text(L.Listen.noSearchResults.localized)
                        .font(DS.Font.callout())
                        .foregroundColor(DS.Colors.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Spacing.xxxl)
            } else {
                // 검색 결과 그리드
                LazyVGrid(columns: DS.Layout.grid(), spacing: DS.Spacing.md) {
                    ForEach(filteredSounds) { sound in
                        SoundCardView(sound: sound, viewModel: viewModel)
                            .onTapGesture {
                                selectSound(sound)
                            }
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(soundCardAccessibilityLabel(sound))
                            .accessibilityAddTraits(.isButton)
                            .accessibilityHint(L.A11y.playSoundHint.localized)
                            .accessibilityAction(named: Text(L.A11y.favorite.localized)) {
                                viewModel.toggleFavorite(sound)
                            }
                            .contextMenu { cardContextMenu(for: sound) }
                    }
                }
                .padding(.horizontal, DS.Spacing.screen)
            }
        }
    }

    // MARK: - Search Bar
    @ViewBuilder
    private func searchBar() -> some View {
        HStack(spacing: DS.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(DS.Colors.textTertiary)
                .accessibilityHidden(true)

            TextField(L.Listen.soundSearch.localized, text: $searchText)
                .foregroundColor(DS.Colors.textPrimary)
                .font(DS.Font.body())
                .tint(DS.Colors.accent)
        }
        .padding(.horizontal, DS.Spacing.md)
        .padding(.vertical, DS.Spacing.sm + 2)
        .background(
            RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous)
                .fill(DS.Colors.surfaceSunken)
        )
        .padding(.horizontal, DS.Spacing.screen)
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

    /// 사운드 수정 화면으로 이동
    private func startEdit(_ sound: CustomSound) {
        if viewModel.isPlaying { viewModel.stopSound() }
        editingSound = sound
        showEditView = true
    }

    /// 사운드 삭제 (내가 만든 사운드만)
    private func deleteSound(_ sound: CustomSound) {
        guard let index = viewModel.customSounds.firstIndex(where: { $0.id == sound.id }) else { return }
        viewModel.remove(at: index)
    }

    /// 카드에 길게 눌러 수정/삭제하는 컨텍스트 메뉴 (내가 만든 사운드 전용)
    @ViewBuilder
    private func cardContextMenu(for sound: CustomSound) -> some View {
        if !sound.isPreset {
            Button {
                startEdit(sound)
            } label: {
                Label(L.Common.edit.localized, systemImage: "slider.horizontal.3")
            }
            Button(role: .destructive) {
                deleteSound(sound)
            } label: {
                Label(L.Common.delete.localized, systemImage: "trash")
            }
        }
    }

    // MARK: - Accessibility
    /// 사운드 카드를 VoiceOver에서 읽어줄 라벨 (제목, 카테고리, 즐겨찾기 상태)
    private func soundCardAccessibilityLabel(_ sound: CustomSound) -> String {
        var parts = [sound.title, sound.category.displayName]
        if sound.isFavorite { parts.append(L.A11y.favoriteOn.localized) }
        return parts.joined(separator: ", ")
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
                // 레이어 사운드면 썸네일, 아니면 부드러운 색 배경
                if sound.isLayeredSound {
                    Rectangle()
                        .fill(DS.Colors.accentSoft)
                        .frame(height: 104)

                    SoundThumbnailView(sound: sound, size: 60)
                } else {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: sound.color).opacity(0.55),
                                    Color(hex: sound.color).opacity(0.85)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 104)

                    // 카테고리 아이콘
                    Image(sound.category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.white.opacity(0.95))
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
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(sound.isFavorite ? DS.Colors.danger : .white)
                                    .frame(width: 34, height: 34)
                                    .background(.ultraThinMaterial, in: Circle())
                            }
                            .padding(DS.Spacing.xs)
                        }
                        Spacer()
                    }
                }

                // 프리셋 배지 (좌측 상단)
                if sound.isPreset {
                    VStack {
                        HStack {
                            HStack(spacing: 3) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 9))
                                Text(L.Listen.presets.localized)
                                    .font(DS.Font.caption().weight(.semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, DS.Spacing.xs)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(DS.Colors.accent.opacity(0.95)))
                            .padding(DS.Spacing.xs)

                            Spacer()
                        }
                        Spacer()
                    }
                }
            }

            // 하단 정보 영역
            VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                Text(sound.title)
                    .font(DS.Font.subhead().weight(.semibold))
                    .foregroundColor(DS.Colors.textPrimary)
                    .lineLimit(1)

                HStack(spacing: DS.Spacing.xxs + 2) {
                    // 레이어 개수 또는 카테고리 표시
                    if let layers = sound.soundLayers, layers.count > 1 {
                        Image(systemName: "square.3.layers.3d")
                            .font(.system(size: 10))
                        Text(String(format: L.Listen.layerCount.localized, layers.count))
                            .font(DS.Font.caption())
                    } else {
                        Image(systemName: "waveform")
                            .font(.system(size: 10))
                        Text(sound.category.displayName)
                            .font(DS.Font.caption())
                    }
                }
                .foregroundColor(DS.Colors.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(DS.Spacing.sm)
            .background(DS.Colors.surface)
        }
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md, style: .continuous))
        .shadow(color: DS.Shadow.card.color, radius: DS.Shadow.card.radius, x: 0, y: DS.Shadow.card.y)
    }
}

// MARK: - Recommendation Card View
struct RecommendationCard: View {
    let sound: CustomSound

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.sm) {
            // 상단 아이콘 영역
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: sound.color).opacity(0.55),
                                Color(hex: sound.color).opacity(0.85)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)

                if sound.isLayeredSound {
                    SoundThumbnailView(sound: sound, size: 32)
                } else {
                    Image(sound.category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.white)
                }
            }

            // 사운드 정보
            VStack(alignment: .leading, spacing: DS.Spacing.xxs) {
                Text(sound.title)
                    .font(DS.Font.subhead().weight(.semibold))
                    .foregroundColor(DS.Colors.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: DS.Spacing.xxs) {
                    Image(systemName: "waveform")
                        .font(.system(size: 9))
                    Text(sound.category.displayName)
                        .font(DS.Font.caption())
                }
                .foregroundColor(DS.Colors.textSecondary)
            }
        }
        .frame(width: 150, alignment: .leading)
        .dsCard(padding: DS.Spacing.md, radius: DS.Radius.md)
    }
}

