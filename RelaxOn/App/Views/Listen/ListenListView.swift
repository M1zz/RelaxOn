//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI
import UIKit
import MediaPlayer
import CoreMotion

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
    @State private var orbTapPress = false   // 재생/일시정지 탭 시 옴폭 눌리는 효과
    // 오브 스와이프(다음 소리) — 손가락 따라 3D로 굴러가는 느낌
    @State private var orbCommitted: Double = 0   // 확정된 회전(전환 시 ±360 누적)
    @State private var orbDragAngle: Double = 0   // 드래그 중 실시간 회전
    // 세로 굴림(모드 전환): 0=보관함(위), 1=홈(구체), 2=타이머(아래)
    @State private var page: Int = 1
    @State private var dragY: CGFloat = 0
    @State private var vLock: Bool? = nil   // nil=미결정, true=세로, false=가로
    // 구체 세로 회전(전환 시 위/아래로 굴러가는 모습)
    @State private var orbCommittedV: Double = 0
    @State private var orbDragV: Double = 0
    // 오디오 전환 디바운스 (스와이프 중 디코딩으로 롤이 끊기는 것 방지)
    @State private var audioSwitchWork: DispatchWorkItem?
    // 달을 돌리면 잠깐 나타나 궤도를 도는 위성
    @State private var satelliteVisible = false
    @State private var satelliteToken = 0
    // 앱 시작 시 구체가 데굴데굴 굴러 들어오는 등장 애니메이션 (매번 다른 위치 + 기울기 방향)
    @State private var orbAppearOffsetX: CGFloat = 0
    @State private var orbAppearOffsetY: CGFloat = 0
    @State private var orbAppearRoll: Double = 0
    @State private var orbAppearRollY: Double = 0
    @State private var orbEntranceReady = false   // 시작 위치를 잡기 전엔 숨김(중앙 깜빡임 방지)
    @State private var didOrbEntrance = false
    @State private var didAutoPlay = false         // 앱 시작 시 우주 앰비언트 1회 자동재생
    @State private var motionManager = CMMotionManager()
    @State private var showNameLabel = false
    @State private var nameLabelText = ""
    @State private var nameToken = 0
    @AppStorage("didShowSwipeHint") private var didShowSwipeHint = false
    // 모드 전환 안내 칩(타이머/보관함): 뉴비에게만 노출 — 써봤거나 몇 번 열면 숨김
    @AppStorage("homeAppearCount") private var homeAppearCount = 0
    @AppStorage("didUseModeSwitch") private var didUseModeSwitch = false
    // 첫 실행 1회 제스처 안내
    @AppStorage("didShowGestureCoach") private var didShowGestureCoach = false
    @State private var showCoach = false
    @State private var countedThisSession = false
    @StateObject private var timerManager = TimerManager(viewModel: CustomSoundViewModel())
    
    // MARK: - Body
    var body: some View {
        // 세로 굴림 페이저: 위로 스와이프=타이머(아래에서 올라옴), 아래로 스와이프=보관함(위에서 내려옴)
        ZStack {
            // 배경만 화면 전체를 채우고, 페이지는 safe area 안에 둬서
            // 중첩 NavigationStack(타이머/보관함)의 상단 바가 상태바에 가리지 않게 한다.
            ScreenBackground().ignoresSafeArea()
            // 우주 느낌의 은은한 별 (홈 배경)
            Starfield().ignoresSafeArea()

            GeometryReader { geo in
                let H = geo.size.height
                let W = geo.size.width
                // 각 페이지를 개별 오프셋으로 배치: 보관함=위(-H), 홈=가운데(0), 타이머=아래(+H)
                ZStack {
                    libraryPage()
                        .frame(width: W, height: H)
                        .offset(y: pageOffset(0, H))
                        .zIndex(page == 0 ? 1 : 0)

                    homePage()
                        .frame(width: W, height: H)
                        .offset(y: pageOffset(1, H))
                        .zIndex(page == 1 ? 1 : 0)

                    timerPage()
                        .frame(width: W, height: H)
                        .offset(y: pageOffset(2, H))
                        .zIndex(page == 2 ? 1 : 0)
                }
                .frame(width: W, height: H)
                .clipped()
            }

            // 첫 실행 1회: 제스처 사용법 안내 (스킵 가능)
            if showCoach {
                GestureCoachmark { dismissCoach() }
                    .zIndex(10)
                    .transition(.opacity)
            }
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

        .trackScreen("Home")
        .onAppear {
            // 앱 실행당 1회만 카운트 (뉴비 안내 칩 노출 판단용)
            if !countedThisSession {
                countedThisSession = true
                homeAppearCount += 1
            }
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

            // 앱 시작 시 1회: 우주 앰비언트(space_1min) 자동 재생 (무한 루프)
            if !didAutoPlay {
                didAutoPlay = true
                let space = CustomSound(title: "Space",
                                        backgroundSound: BackgroundSound.space.rawValue,
                                        backgroundVolume: 0.5)
                viewModel.selectedSound = space
                viewModel.lastSound = space
                viewModel.play(with: space)
            }

            // 처음 한 번: 옆으로 넘기면 소리가 바뀐다는 힌트
            if !didShowSwipeHint {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    flashLabel(L.Listen.swipeHint.localized, duration: 3.5)
                    didShowSwipeHint = true
                }
            }

            // 잠금화면/제어센터 컨트롤 연결
            setupNowPlaying()

            // 앱 시작 시 1회: 기기 기울기(중력)를 읽어 그 방향에서 데굴데굴 굴러옴
            if !didOrbEntrance {
                didOrbEntrance = true
                // 기울기 샘플을 얻기 위해 모션 업데이트 시작
                if motionManager.isDeviceMotionAvailable {
                    motionManager.deviceMotionUpdateInterval = 0.05
                    motionManager.startDeviceMotionUpdates()
                }
                // 잠깐 기다렸다 중력 읽고 → 그 방향 화면 밖에서 굴러 들어옴
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                    let start = computeEntranceStart()
                    motionManager.stopDeviceMotionUpdates()
                    orbAppearOffsetX = start.x
                    orbAppearOffsetY = start.y
                    orbAppearRoll = start.roll
                    orbAppearRollY = start.rollY
                    orbEntranceReady = true   // 시작 위치(화면 밖)에서 등장
                    // 다음 런루프에 가운데로 굴러오기 (시작값이 먼저 반영되어야 애니메이션됨)
                    DispatchQueue.main.async {
                        withAnimation(.spring(response: 0.85, dampingFraction: 0.62)) {
                            orbAppearOffsetX = 0
                            orbAppearOffsetY = 0
                            orbAppearRoll = 0
                            orbAppearRollY = 0
                        }
                        // 착지하는 순간 살짝 눌리는(누르는) 느낌
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.62) {
                            withAnimation(.easeOut(duration: 0.1)) { orbPressed = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { orbPressed = false }
                            }
                        }
                    }
                }
            } else {
                orbEntranceReady = true   // 이미 등장했으면 그냥 보이게
            }

            // 첫 실행 1회: 구체가 굴러 들어온 뒤 제스처 안내를 띄움
            if !didShowGestureCoach {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation(.easeInOut(duration: 0.4)) { showCoach = true }
                }
            }
        }
        // 재생 상태/곡 변경 시 잠금화면 정보 갱신
        .onChange(of: viewModel.isPlaying) { _, _ in updateNowPlaying() }
        .onChange(of: currentSoundTitle) { _, _ in updateNowPlaying() }
    }

    private func dismissCoach() {
        didShowGestureCoach = true
        withAnimation(.easeInOut(duration: 0.3)) { showCoach = false }
    }

    // MARK: - Vertical Pager Pages

    /// 모드 전환 안내 칩 노출 여부 — 아직 한 번도 안 써봤고, 앱을 3번 미만 열었을 때만
    private var showModeHints: Bool {
        !didUseModeSwitch && homeAppearCount < 3
    }

    /// 등장 시작 위치/회전 계산: 기기가 기울어진 방향(중력)에서, 매번 다른 높이에서 굴러오게
    private func computeEntranceStart() -> (x: CGFloat, y: CGFloat, roll: Double, rollY: Double) {
        let distance = CGFloat.random(in: 340...440)
        let gravity = motionManager.deviceMotion?.gravity

        // 가로 방향: 기울기가 뚜렷하면 그쪽에서, 아니면(시뮬레이터 등) 랜덤
        let horiz: Double
        if let g = gravity, abs(g.x) > 0.06 {
            horiz = g.x > 0 ? 1 : -1   // 오른쪽으로 기울면 오른쪽에서 굴러옴
        } else {
            horiz = Bool.random() ? 1 : -1
        }
        // 세로 시작 높이는 매번 랜덤 → 실행마다 다른 위치에서 굴러옴
        let vert = Double.random(in: -0.65...0.65)

        let startX = CGFloat(horiz) * distance
        let startY = CGFloat(vert) * 260
        // 이동량에 비례한 회전 → 실제로 굴러오는 모습
        return (startX, startY, Double(startX) * 1.05, Double(startY) * 1.05)
    }

    /// 재생/일시정지 탭 시: 안쪽으로 옴폭 눌렸다가 스프링으로 통통 튀어나옴
    private func pressOrb() {
        withAnimation(.easeIn(duration: 0.08)) { orbTapPress = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            withAnimation(.spring(response: 0.34, dampingFraction: 0.42)) { orbTapPress = false }
        }
    }

    /// page 1 — 홈(구체). 탭=재생/일시정지, 좌우=다음 소리, 위/아래=모드 전환
    @ViewBuilder
    private func homePage() -> some View {
        let timerActive = timerManager.textTimer != nil && timerManager.remainingSeconds > 0
        VStack(spacing: 0) {
            Spacer()

            // 위로 굴리면 타이머 (탭으로도 열림) — 뉴비에게만 안내
            if showModeHints {
                modeHint(icon: "chevron.up", title: L.A11y.timerButton.localized, active: timerActive) {
                    goTo(2)
                }
                .padding(.bottom, DS.Spacing.lg)
                .transition(.opacity)
            }

            // 메인 오브
            VStack(spacing: DS.Spacing.md) {
                ZStack {
                    CampfireView(isPlaying: viewModel.isPlaying,
                                 tint: orbTint,
                                 roll: orbCommitted + orbDragAngle + orbAppearRoll,
                                 rollY: orbCommittedV + orbDragV + orbAppearRollY,
                                 satelliteVisible: satelliteVisible)
                    .scaleEffect(orbPressed ? 0.97 : 1.0)
                    .scaleEffect(orbTapPress ? 0.92 : 1.0)              // 탭 시 옴폭
                    .offset(x: orbAppearOffsetX, y: orbAppearOffsetY)   // 등장 시 기울어진 방향에서 굴러옴
                    .opacity(orbEntranceReady ? 1 : 0)                  // 시작 위치 잡기 전 숨김
                    .animation(.easeInOut(duration: 0.6), value: orbTint)
                    .accessibilityElement()
                    .accessibilityLabel(viewModel.isPlaying ? L.A11y.pause.localized : L.A11y.play.localized)
                    .accessibilityValue(currentSoundTitle)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction(named: Text(L.A11y.nextSound.localized)) { nextSound() }
                    .accessibilityAction(named: Text(L.A11y.timerButton.localized)) { goTo(2) }
                    .accessibilityAction(named: Text(L.A11y.savedSoundsButton.localized)) { goTo(0) }
                }

                Text(nameLabelText)
                    .font(DS.Font.callout())
                    .foregroundColor(DS.Colors.textSecondary)
                    .lineLimit(1)
                    .opacity(showNameLabel ? 1 : 0)
                    .frame(height: 22)
                    .accessibilityHidden(true)
            }

            // 아래로 굴리면 보관함 — 뉴비에게만 안내
            if showModeHints {
                modeHint(icon: "chevron.down", title: L.A11y.savedSoundsButton.localized, active: false) {
                    goTo(0)
                }
                .padding(.top, DS.Spacing.lg)
                .transition(.opacity)
            }

            Spacer()
        }
        .dsConstrainedWidth()
        // 스와이프 영역을 화면 전체로 — 빈 곳에서도 탭/좌우/상하 제스처가 동작한다.
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .gesture(orbGesture())
        .allowsHitTesting(page == 1)
    }

    /// 위/아래 굴림 안내 + 탭 단축 (작은 글래스 칩)
    @ViewBuilder
    private func modeHint(icon: String, title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: DS.Spacing.xxs) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(title)
                    .font(DS.Font.caption().weight(.medium))
            }
            .foregroundColor(active ? DS.Colors.accent : DS.Colors.textSecondary.opacity(0.7))
            .padding(.horizontal, DS.Spacing.md)
            .padding(.vertical, DS.Spacing.xs)
            .background(
                Capsule().fill(DS.Colors.surfaceSunken.opacity(0.5))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }

    /// page 0 — 보관함 (위에서 내려옴). 자체 커스텀 헤더(닫기+제목+추가) 사용.
    @ViewBuilder
    private func libraryPage() -> some View {
        SavedSoundsListView(onClose: { goTo(1) })
            .allowsHitTesting(page == 0)
    }

    /// page 2 — 타이머 (아래에서 올라옴)
    @ViewBuilder
    private func timerPage() -> some View {
        TimerView(timerManager: timerManager,
                  isShowingTimer: Binding(get: { page == 2 },
                                          set: { if !$0 { goTo(1) } }))
            .safeAreaInset(edge: .top) {
                pageTopBar(icon: "chevron.up",
                           title: L.Timer.sleepTimer.localized,
                           onClose: { goTo(1) })
            }
            .allowsHitTesting(page == 2)
    }

    /// 페이지 상단 커스텀 바 (중첩 NavigationStack 없이 닫기 chevron + 제목)
    @ViewBuilder
    private func pageTopBar(icon: String, title: String, onClose: @escaping () -> Void) -> some View {
        HStack(spacing: DS.Spacing.xs) {
            Button(action: onClose) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(DS.Colors.accent)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(L.Common.close.localized)

            Spacer()

            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(DS.Colors.textPrimary)
                .lineLimit(1)

            Spacer()

            // 좌우 균형용 더미 (제목 가운데 정렬)
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, DS.Spacing.sm)
        .background(.ultraThinMaterial)
    }

    // MARK: - Orb Gesture (탭 / 좌우 소리 전환 / 상하 모드 전환)
    private func orbGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let adx = abs(value.translation.width)
                let ady = abs(value.translation.height)
                if vLock == nil, max(adx, ady) > 10 {
                    vLock = ady > adx   // 처음 의미있게 움직인 축으로 고정
                }
                if vLock == true {
                    // 세로: 구체만 손가락 따라 굴림 (화면은 그대로 — 다 구른 뒤 전환)
                    orbDragV = max(-170, min(170, Double(value.translation.height) * 0.5))
                } else if vLock == false {
                    orbPressed = true
                    orbDragAngle = max(-85, min(85, Double(value.translation.width) * 0.55))
                }
            }
            .onEnded { value in
                let dx = value.translation.width
                let dy = value.translation.height
                if vLock == true {
                    // 세로 굴림 → 모드 전환 (구체가 그 방향으로 굴러가며 전환)
                    let predicted = value.predictedEndTranslation.height
                    let decisive = abs(dy) > abs(predicted) ? dy : predicted
                    if decisive < -40 { goTo(2) }        // 위로 → 타이머
                    else if decisive > 40 { goTo(0) }    // 아래로 → 보관함
                    else {
                        // 부족하면 도로 제자리 (구체도 원위치)
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                            orbDragV = 0
                        }
                    }
                } else if vLock == false {
                    // 가로 굴림 → 다음 소리
                    let predicted = value.predictedEndTranslation.width
                    if abs(dx) > 24 || abs(predicted) > 60 {
                        let dec = abs(dx) > abs(predicted) ? dx : predicted
                        let dir: Double = dec < 0 ? -1 : 1
                        withAnimation(.easeOut(duration: 0.6)) {
                            orbCommitted += dir * 360
                            orbDragAngle = 0
                            orbPressed = false
                        }
                        flashSatellite()   // 달을 돌리면 위성이 나와서 궤도를 돈다
                        nextSound()
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            orbDragAngle = 0
                            orbPressed = false
                        }
                    }
                } else {
                    // 거의 안 움직임 → 탭 = 재생/일시정지 (옴폭 눌렸다 나오는 효과)
                    if hypot(dx, dy) < 10 {
                        togglePlay()
                        pressOrb()
                    }
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        orbDragAngle = 0
                        orbPressed = false
                    }
                }
                vLock = nil
            }
    }

    /// 페이지 i의 세로 오프셋 (전환은 page 값으로만 — 구체가 다 구른 뒤 슬라이드)
    private func pageOffset(_ i: Int, _ H: CGFloat) -> CGFloat {
        CGFloat(i - page) * H
    }

    /// 모드 전환: ① 구체가 제자리에서 한 바퀴 다 굴러가고 → ② 화면이 슬라이드 전환.
    private func goTo(_ p: Int) {
        let from = page
        guard p != from else { return }
        Haptics.light()
        didUseModeSwitch = true   // 한 번 써봤으면 안내 칩은 다음부터 숨김
        let dir = p > from ? 1.0 : -1.0
        let rollDur = 0.5

        if from == 1 {
            // 홈 출발: 구체가 한 바퀴 굴러가며(가속) → 끝나기 직전 화면이 슬라이드(감속)로
            // 이어받아 멈칫 없이 흐른다.
            withAnimation(.easeIn(duration: rollDur)) {
                orbCommittedV -= 360 * dir   // 손가락 따라 굴러간 상태에서 이어서 한 바퀴
                orbDragV = 0
            }
            // 회전이 거의 끝난 시점(82%)에 슬라이드를 겹쳐 시작 → 이음매 정지 제거
            DispatchQueue.main.asyncAfter(deadline: .now() + rollDur * 0.82) {
                withAnimation(.easeOut(duration: 0.4)) { page = p }
            }
        } else {
            // 홈으로 복귀: 구체가 가려져 안 보이므로 바로 슬라이드 (회전값은 원위치로 정렬)
            withAnimation(.easeInOut(duration: 0.42)) { page = p }
            orbCommittedV -= 360 * dir
            orbDragV = 0
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
        Haptics.soft()
        audioSwitchWork?.cancel() // 대기 중인 스와이프 오디오 전환 취소
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
        Haptics.selection()
        let idx = pool.firstIndex(where: { $0.id == viewModel.selectedSound?.id }) ?? -1
        let next = pool[(idx + 1) % pool.count]
        // 색/제목은 즉시 갱신(가벼움) — 시각 피드백은 바로
        viewModel.selectedSound = next
        flashLabel(next.title)
        // 오디오 전환은 디바운스: 연속 스와이프 중엔 디코딩하지 않고,
        // 멈춘 뒤(롤 애니메이션이 끝난 시점) 최종 선택된 소리만 한 번 로딩 → 롤이 끊기지 않음
        scheduleAudioSwitch()
    }

    /// 무거운 오디오 로딩(파일 디코딩)을 롤 애니메이션 이후로 미뤄, 스와이프 중 메인 스레드 블록을 방지
    private func scheduleAudioSwitch() {
        audioSwitchWork?.cancel()
        guard viewModel.isPlaying else { return } // 멈춰 있으면 선택만 바꿈
        let work = DispatchWorkItem { [weak viewModel] in
            guard let viewModel, viewModel.isPlaying, let target = viewModel.selectedSound else { return }
            viewModel.play(with: target) // 페이드 인으로 부드럽게
        }
        audioSwitchWork = work
        // 롤(0.6s)이 끝난 뒤 실행 → 디코딩 블록이 정지 상태의 구체에서 일어나 눈에 띄지 않음
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.62, execute: work)
    }

    /// 이전 배경음으로 전환 (처음이면 마지막으로 순환). 잠금화면 ⏮ 버튼용.
    private func prevSound() {
        let pool = viewModel.customSounds
        guard !pool.isEmpty else { return }
        let idx = pool.firstIndex(where: { $0.id == viewModel.selectedSound?.id }) ?? 0
        let prev = pool[(idx - 1 + pool.count) % pool.count]
        let wasPlaying = viewModel.isPlaying
        viewModel.selectedSound = prev
        if wasPlaying {
            viewModel.play(with: prev)
        }
        flashLabel(prev.title)
    }

    // MARK: - Now Playing (잠금화면 / 제어센터)
    /// 리모트 커맨드를 한 번 등록하고 현재 상태를 잠금화면에 반영
    private func setupNowPlaying() {
        let np = NowPlayingManager.shared
        np.setupRemoteCommands()
        np.onPlay = { if !viewModel.isPlaying { togglePlay() } }
        np.onPause = { if viewModel.isPlaying { togglePlay() } }
        np.onToggle = { togglePlay() }
        np.onNext = { nextSound() }
        np.onPrevious = { prevSound() }
        updateNowPlaying()
    }

    /// 현재 곡 제목/재생 상태/색을 잠금화면 정보에 반영
    private func updateNowPlaying() {
        NowPlayingManager.shared.update(
            title: currentSoundTitle,
            isPlaying: viewModel.isPlaying,
            tint: UIColor(orbTint)
        )
    }

    /// 달을 돌릴 때 위성을 잠깐(궤도 두어 바퀴) 나타냈다 사라지게
    private func flashSatellite(duration: Double = 3.0) {
        satelliteVisible = true
        satelliteToken += 1
        let token = satelliteToken
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if token == satelliteToken { satelliteVisible = false }
        }
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

/// 구 표면(질감 점 + 아이콘)만 따로 그리는 뷰.
/// Animatable 채택 → SwiftUI가 offset/opacity 최종값이 아니라 "회전각(roll) 자체"를
/// 보간하고 매 프레임 sin/cos를 다시 계산한다. (안 그러면 roll 0→-360 시 시작·끝 위치가
/// 같아서 "변화 없음"으로 처리되어 아이콘이 안 굴러간다.)
struct RollingSphereSurface: View, Animatable {
    var roll: Double            // 가로 회전 각도(도) — 좌우 굴림(소리 전환)
    var rollY: Double           // 세로 회전 각도(도) — 위아래 굴림(모드 전환)
    let isPlaying: Bool
    var showIcon: Bool = true    // 재생/일시정지 심볼 표시
    var showSpots: Bool = true   // 분화구(크레이터) 표시
    var iconColor: Color = .white

    // 두 축을 함께 보간 → 가로/세로 모두 표면 회전이 실제로 굴러간다.
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(roll, rollY) }
        set { roll = newValue.first; rollY = newValue.second }
    }

    private let sphereR: CGFloat = 104
    private var rx: Double { roll * .pi / 180 }
    private var ry: Double { rollY * .pi / 180 }

    // 표면 위 한 점(경도 lon, 기준 y=baseY)의 화면 투영: 위치·압축·가시성
    private func markX(_ lon: Double) -> CGFloat { CGFloat(sin(rx + lon)) * sphereR }
    private func markY(_ baseY: CGFloat) -> CGFloat { baseY * CGFloat(cos(ry)) + CGFloat(sin(ry)) * sphereR }
    private func squashX(_ lon: Double) -> CGFloat { CGFloat(max(0.05, abs(cos(rx + lon)))) }
    private func squashY() -> CGFloat { CGFloat(max(0.05, abs(cos(ry)))) }
    // 앞면(양 축 모두 정면)일 때만 보임
    private func markOpacity(_ lon: Double) -> Double { max(0, cos(rx + lon)) * max(0, cos(ry)) }

    private struct Spot {
        let lon: Double; let y: CGFloat; let size: CGFloat; let light: Bool; let maxOpacity: Double
    }
    // 달 표면: 큰 바다(어두운 마리아) + 작은 크레이터(밝은 점)들이 섞여 달처럼 보이게
    private static let spots: [Spot] = [
        Spot(lon: 1.5, y: 28,  size: 74, light: false, maxOpacity: 0.28),  // 큰 마리아
        Spot(lon: 4.2, y: 6,   size: 62, light: false, maxOpacity: 0.24),
        Spot(lon: 2.4, y: -36, size: 50, light: false, maxOpacity: 0.20),
        Spot(lon: 0.7, y: -8,  size: 34, light: false, maxOpacity: 0.18),
        Spot(lon: 3.1, y: 48,  size: 38, light: false, maxOpacity: 0.16),
        Spot(lon: 5.3, y: -42, size: 28, light: false, maxOpacity: 0.16),
        Spot(lon: 1.0, y: 54,  size: 20, light: false, maxOpacity: 0.18),
        Spot(lon: 2.0, y: 62,  size: 22, light: true,  maxOpacity: 0.20),  // 밝은 크레이터
        Spot(lon: 4.9, y: 34,  size: 18, light: true,  maxOpacity: 0.18),
        Spot(lon: 3.7, y: -20, size: 16, light: true,  maxOpacity: 0.16)
    ]

    var body: some View {
        ZStack {
            // 분화구(크레이터) — 표면을 따라 굴러간다
            if showSpots {
                ForEach(Self.spots.indices, id: \.self) { i in
                    craterView(Self.spots[i])
                }
            }
            // 표면 위 재생/일시정지 심볼 — 표면과 함께 굴러간다
            if showIcon {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(iconColor)
                    .scaleEffect(x: squashX(0), y: squashY(), anchor: .center)
                    .offset(x: markX(0) + (isPlaying ? 0 : 5), y: markY(0))
                    .opacity(markOpacity(0))
            }
        }
    }

    /// 분화구 1개 — 테두리 없이 부드럽고 흐릿한 얼룩으로 (또렷한 문양이 아니라 은은한 질감)
    @ViewBuilder
    private func craterView(_ s: Spot) -> some View {
        let base = s.light ? Color.white : Color(white: 0.28)
        Circle()
            .fill(
                RadialGradient(
                    colors: [base.opacity(s.maxOpacity), .clear],
                    center: .center, startRadius: 0, endRadius: s.size * 0.78
                )
            )
            .frame(width: s.size * 1.7, height: s.size * 1.7)
            .scaleEffect(x: squashX(s.lon), y: squashY(), anchor: .center)
            .offset(x: markX(s.lon), y: markY(s.y))
            .opacity(markOpacity(s.lon))
    }
}

// MARK: - Moon Phase Shadow

/// 달 위상 그림자: phase 1 = 보름달(그림자 없음), 0 = 반달, -1 = 신월(전부 그림자).
/// 오른쪽에서 그림자가 차오르며 보름→반달→초승달로 변한다. Animatable로 부드럽게 보간.
struct MoonShadow: Shape, Animatable {
    var phase: Double
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let r = rect.width / 2
        let cx = rect.midX, cy = rect.midY
        let k = CGFloat(max(-1, min(1, phase)))
        let steps = 96
        var pts: [CGPoint] = []
        // 명암 경계(터미네이터) 타원: 위(y=-r) → 아래(y=+r)
        for i in 0...steps {
            let t = CGFloat(i) / CGFloat(steps)
            let y = -r + 2 * r * t
            let xr = sqrt(max(0, r * r - y * y))
            pts.append(CGPoint(x: cx + k * xr, y: cy + y))
        }
        // 터미네이터 오른쪽을 원 밖까지 가득 채움 → 바깥의 clipShape(Circle)이 림에 정확히 맞춰 자른다
        // (외곽을 원호로 근사하지 않으므로 달이 삐져나오지 않음)
        pts.append(CGPoint(x: rect.maxX + r, y: rect.maxY + r))
        pts.append(CGPoint(x: rect.maxX + r, y: rect.minY - r))
        p.addLines(pts)
        p.closeSubpath()
        return p
    }
}

/// 홈의 메인 오브 — "달". 재생을 시작하면 그림자가 차올라 보름달→반달→초승달로 변한다.
struct CampfireView: View {
    let isPlaying: Bool
    var tint: Color = DS.Colors.accent
    var roll: Double = 0    // 가로 회전(좌우 굴림)
    var rollY: Double = 0   // 세로 회전(위아래 굴림)
    var satelliteVisible: Bool = false   // 달을 돌리면 위성이 나와서 궤도를 돈다

    @State private var breathe = false
    @State private var glow = false
    @State private var moonPhase: Double = 1.0   // 1=보름달, 0=반달, -1=신월
    @State private var satOpacity: Double = 0    // 위성 표시 정도
    @State private var satEmerge: Double = 0     // 위성이 달에서 "나오는" 정도(궤도 반지름 비율)

    private let moonSize: CGFloat = 220

    var body: some View {
        ZStack {
            // 달무리(외곽 글로우)
            Circle()
                .fill(
                    RadialGradient(
                        colors: [tint.opacity(isPlaying ? 0.30 : 0.14),
                                 Color.white.opacity(isPlaying ? 0.10 : 0.05),
                                 .clear],
                        center: .center, startRadius: 10, endRadius: 220
                    )
                )
                .frame(width: 320, height: 320)
                .scaleEffect(glow ? 1.06 : 0.9)
                .blur(radius: 34)

            // 위성 — 궤도 뒤쪽 반(달 뒤로 지나감)
            if satOpacity > 0.001 || satelliteVisible {
                satelliteView(front: false)
            }

            // 본체 — 소리마다 바뀌는 색(틴트)의 매끈한 구체
            moonView

            // 위성 — 궤도 앞쪽 반(달 앞으로 지나감)
            if satOpacity > 0.001 || satelliteVisible {
                satelliteView(front: true)
            }
        }
        .frame(width: 240, height: 240)
        .onAppear {
            startBreathing()
            if isPlaying { startMoonCycle() } else { moonPhase = 1.0 }
        }
        .onChange(of: isPlaying) { _, playing in
            startBreathing()
            if playing {
                startMoonCycle()
            } else {
                // 일시정지 → 천천히 보름달로 복귀
                withAnimation(.easeInOut(duration: 6)) { moonPhase = 1.0 }
            }
        }
        .onChange(of: satelliteVisible) { _, v in
            // 나올 땐 빠르게 솟아오르고, 사라질 땐 천천히 달 속으로 들어감
            withAnimation(.easeOut(duration: v ? 0.5 : 0.8)) {
                satOpacity = v ? 1 : 0
                satEmerge = v ? 1 : 0
            }
        }
    }

    /// 위성: 기울어진 타원 궤도를 연속으로 돈다. front=true면 앞쪽 반, false면 뒤쪽 반만 그려
    /// 달 뒤로 자연스럽게 사라졌다 앞으로 나타난다. TimelineView로 매 프레임 위치를 다시 계산.
    @ViewBuilder
    private func satelliteView(front: Bool) -> some View {
        TimelineView(.animation) { context in
            let period = 600.0   // 한 바퀴(초) — 10분에 한 바퀴, 아주 느리게
            let t = context.date.timeIntervalSinceReferenceDate
            let phase = (t / period).truncatingRemainder(dividingBy: 1)
            let ang = phase * 2 * Double.pi
            // 기울어진 궤도: 가로 넓고 세로 얕게. 아래쪽(앞)일수록 앞·크게, 위쪽(뒤)이면 작게
            let frontness = -cos(ang)              // +면 앞(아래), -면 뒤(위)
            let isFrontHalf = frontness > 0
            let rx = 142.0, ry = 48.0
            let x = sin(ang) * rx * satEmerge
            let y = (-cos(ang) * ry * satEmerge) - 6
            let scale = 0.82 + 0.3 * max(0, frontness)
            ZStack {
                // 위성 둘레의 밝은 빛무리 (대비 확보)
                Circle()
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 44, height: 44)
                    .blur(radius: 11)
                // 위성 본체 — 작은 달(밝은 흰색, 한쪽만 살짝 음영)
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.white, Color(white: 0.95), Color(white: 0.72)],
                            center: UnitPoint(x: 0.36, y: 0.3),
                            startRadius: 1, endRadius: 18
                        )
                    )
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(Color.white.opacity(0.7), lineWidth: 0.5))
                    .shadow(color: tint.opacity(0.7), radius: 6)
            }
            .scaleEffect(scale)
            .offset(x: x, y: y)
            .opacity((isFrontHalf == front) ? satOpacity : 0)
        }
        .allowsHitTesting(false)
    }

    /// 달 본체 (식이 길어 별도 프로퍼티로 분리 — 컴파일러 타입체크 부담 완화)
    private var moonView: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [tint.opacity(0.95), tint.opacity(0.60)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
            )
            .frame(width: moonSize, height: moonSize)
            // 불투명 베이스 — 달 뒤로 지나가는 위성이 비쳐 보이지 않게 한다.
            // (배경색과 동일 → 기존 반투명 룩은 그대로 유지하면서 뒤쪽만 가림)
            .background(Circle().fill(DS.Colors.background))
            .overlay(lightTexture)   // 여러 빛 → 불균일 질감
            // 흐릿한 분화구 — 표면을 따라 굴러감
            .overlay(
                RollingSphereSurface(roll: roll, rollY: rollY, isPlaying: isPlaying,
                                     showIcon: false, showSpots: true)
                    .frame(width: moonSize, height: moonSize)
                    .opacity(0.5)
            )
            // 위상 그림자 — 원 밖까지 채워 림에 딱 맞고, 경계(터미네이터)는 블러로 흐리게
            .overlay(
                MoonShadow(phase: moonPhase)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.05, green: 0.06, blue: 0.13),
                                     Color(red: 0.09, green: 0.10, blue: 0.20)],
                            startPoint: .trailing, endPoint: .leading
                        )
                    )
                    .opacity(0.9)
                    .blur(radius: 7)   // 그림자 경계를 부드럽게
            )
            // 가장자리 음영
            .overlay(
                Circle().strokeBorder(Color.black.opacity(0.12), lineWidth: 1.5)
                    .blur(radius: 1)
            )
            // 재생/일시정지 심볼 (그림자 위, 위상에 따라 색 대비)
            .overlay(
                RollingSphereSurface(
                    roll: roll, rollY: rollY, isPlaying: isPlaying,
                    showIcon: true, showSpots: false,
                    iconColor: moonPhase > 0 ? Color(red: 0.18, green: 0.16, blue: 0.10) : .white
                )
                .frame(width: moonSize, height: moonSize)
            )
            .clipShape(Circle())
            .scaleEffect(breathe ? 1.035 : 0.97)
            .shadow(color: tint.opacity(0.35), radius: 36, x: 0, y: 12)
    }

    /// 여러 곳에서 쏜 빛(밝은 빛 4 + 그늘 3)을 묶은 불균일 질감 레이어
    private var lightTexture: some View {
        ZStack {
            lightBlob(0.30, 0.26, 0.60, 130, true)
            lightBlob(0.72, 0.38, 0.34, 86, true)
            lightBlob(0.44, 0.76, 0.26, 100, true)
            lightBlob(0.18, 0.56, 0.22, 72, true)
            lightBlob(0.78, 0.80, 0.34, 88, false)
            lightBlob(0.55, 0.12, 0.26, 66, false)
            lightBlob(0.40, 0.42, 0.16, 50, false)
        }
    }

    /// 재생 중: 약 10분에 걸쳐 보름달 → 그믐달, 다시 약 10분에 걸쳐 보름달로 (무한 반복)
    private func startMoonCycle() {
        withAnimation(.easeInOut(duration: 600).repeatForever(autoreverses: true)) {
            moonPhase = -0.92   // 그믐달(아주 얇은 달)
        }
    }

    /// 한 지점에서 쏜 빛(또는 그늘) — 여러 개 겹쳐 불균일한 표면 질감을 만든다
    @ViewBuilder
    private func lightBlob(_ x: Double, _ y: Double, _ op: Double, _ r: CGFloat, _ light: Bool) -> some View {
        Circle().fill(
            RadialGradient(
                colors: [(light ? Color.white : Color.black).opacity(op), .clear],
                center: UnitPoint(x: x, y: y), startRadius: 2, endRadius: r
            )
        )
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

// MARK: - Now Playing Manager (잠금화면 / 제어센터 컨트롤)

/// 잠금화면·제어센터·이어폰 버튼으로 재생/일시정지/다음/이전을 제어하고,
/// 현재 곡 정보를 표시한다. 콜백(onPlay 등)은 화면에서 주입한다.
final class NowPlayingManager {
    static let shared = NowPlayingManager()
    private init() {}

    var onPlay: (() -> Void)?
    var onPause: (() -> Void)?
    var onToggle: (() -> Void)?
    var onNext: (() -> Void)?
    var onPrevious: (() -> Void)?

    private var configured = false

    /// 리모트 커맨드 등록 (앱 생애 1회)
    func setupRemoteCommands() {
        guard !configured else { return }
        configured = true

        let center = MPRemoteCommandCenter.shared()
        center.playCommand.addTarget { [weak self] _ in
            self?.onPlay?(); return .success
        }
        center.pauseCommand.addTarget { [weak self] _ in
            self?.onPause?(); return .success
        }
        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            self?.onToggle?(); return .success
        }
        center.nextTrackCommand.addTarget { [weak self] _ in
            self?.onNext?(); return .success
        }
        center.previousTrackCommand.addTarget { [weak self] _ in
            self?.onPrevious?(); return .success
        }
        [center.playCommand, center.pauseCommand, center.togglePlayPauseCommand,
         center.nextTrackCommand, center.previousTrackCommand].forEach { $0.isEnabled = true }
    }

    /// 잠금화면에 표시할 곡 정보 갱신
    func update(title: String, isPlaying: Bool, tint: UIColor) {
        var info: [String: Any] = [:]
        info[MPMediaItemPropertyTitle] = title
        info[MPMediaItemPropertyArtist] = "달빛"
        info[MPNowPlayingInfoPropertyIsLiveStream] = true   // 백색소음 = 무한 재생(스크러버 숨김)
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0

        let art = Self.artwork(tint: tint)
        info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: art.size) { _ in art }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
    }

    /// 곡 색에 맞춘 단순한 구체 아트워크 생성
    private static func artwork(tint: UIColor) -> UIImage {
        let size = CGSize(width: 400, height: 400)
        return UIGraphicsImageRenderer(size: size).image { ctx in
            UIColor(white: 0.07, alpha: 1).setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            tint.setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 90, y: 90, width: 220, height: 220))
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
    /// 페이저에 임베드될 때 닫기(홈으로) 콜백. nil이면 일반 네비게이션 화면으로 동작.
    var onClose: (() -> Void)? = nil

    var body: some View {
        ZStack {
            ScreenBackground()

            if viewModel.customSounds.isEmpty {
                emptyStateView()
            } else {
                soundsListView()
            }
        }
        // 임베드 모드: 중첩 NavigationStack 대신 상단에 커스텀 헤더(닫기+제목+추가)를 둔다.
        .safeAreaInset(edge: .top) {
            if let onClose { embeddedHeader(onClose: onClose) }
        }
        .navigationTitle(onClose == nil ? L.Listen.savedSounds.localized : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // 제목이 잘리지 않도록 우측에는 컴팩트한 '+' 버튼 하나만 둔다. (일반 모드에서만)
            if onClose == nil {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { createTapped() } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(DS.Colors.accent)
                    }
                    .accessibilityLabel(L.A11y.createNewButton.localized)
                }
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

    // 새 사운드 만들기 (무료 한도 체크)
    private func createTapped() {
        let userCount = viewModel.customSounds.filter { !$0.isPreset }.count
        if subscriptionManager.canCreateMoreSounds(currentCount: userCount) {
            showCreateView = true
        } else {
            showSubscription = true
        }
    }

    // MARK: - Embedded Header (페이저용 상단 바)
    @ViewBuilder
    private func embeddedHeader(onClose: @escaping () -> Void) -> some View {
        HStack(spacing: DS.Spacing.xs) {
            Button(action: onClose) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(DS.Colors.accent)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(L.Common.close.localized)

            Spacer()

            Text(L.Listen.savedSounds.localized)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(DS.Colors.textPrimary)
                .lineLimit(1)

            Spacer()

            Button(action: createTapped) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(DS.Colors.accent)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel(L.A11y.createNewButton.localized)
        }
        .padding(.horizontal, DS.Spacing.sm)
        .background(.ultraThinMaterial)
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

    // MARK: - Sounds List (네이티브 List + 스와이프: 삭제/즐겨찾기)
    private func soundsListView() -> some View {
        VStack(spacing: 0) {
            // 무료 카운트 + 검색
            VStack(spacing: DS.Spacing.sm) {
                if !subscriptionManager.isPremium {
                    let userCount = viewModel.customSounds.filter { !$0.isPreset }.count
                    let reached = userCount >= SubscriptionManager.freeMaxCustomSounds
                    HStack(spacing: DS.Spacing.xxs) {
                        Image(systemName: "person.fill").font(.system(size: 11, weight: .semibold))
                        Text(String(format: L.SoundList.freeCount.localized, userCount, SubscriptionManager.freeMaxCustomSounds))
                            .font(DS.Font.caption().weight(.semibold))
                        Spacer()
                    }
                    .foregroundColor(reached ? DS.Colors.warm : DS.Colors.textSecondary)
                }
                searchBar()
            }
            .padding(.horizontal, DS.Spacing.screen)
            .padding(.top, DS.Spacing.sm)
            .padding(.bottom, DS.Spacing.xs)

            List {
                if searchText.isEmpty {
                    ForEach(PresetCategory.allCases, id: \.self) { category in
                        if let presets = groupedPresets[category], !presets.isEmpty {
                            Section(category.displayName) {
                                ForEach(presets) { soundRow($0) }
                            }
                        }
                    }
                    if !myCreatedSounds.isEmpty {
                        Section(L.Listen.mySounds.localized) {
                            ForEach(myCreatedSounds) { soundRow($0) }
                        }
                    }
                } else {
                    Section(L.Listen.searchResults.localized) {
                        if filteredSounds.isEmpty {
                            Text(L.Listen.noSearchResults.localized)
                                .font(DS.Font.callout())
                                .foregroundColor(DS.Colors.textSecondary)
                                .listRowBackground(Color.clear)
                        } else {
                            ForEach(filteredSounds) { soundRow($0) }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    /// 프리셋을 카테고리별로 그룹화
    private var groupedPresets: [PresetCategory: [CustomSound]] {
        Dictionary(grouping: viewModel.presetSounds) { preset in
            PresetSound.allPresets.first(where: { $0.localizedName == preset.title })?.category ?? .sleep
        }
    }

    // MARK: - Sound Row (이름만 — 삭제/즐겨찾기는 스와이프)
    @ViewBuilder
    private func soundRow(_ sound: CustomSound) -> some View {
        HStack(spacing: DS.Spacing.sm) {
            Text(sound.title)
                .font(DS.Font.callout())
                .foregroundColor(DS.Colors.textPrimary)
                .lineLimit(2)
            Spacer(minLength: 0)
            if sound.isFavorite {
                Image(systemName: "star.fill")
                    .font(.system(size: 12))
                    .foregroundColor(DS.Colors.warm)
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture { selectSound(sound) }
        .listRowBackground(Color.clear)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(soundCardAccessibilityLabel(sound))
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(L.A11y.playSoundHint.localized)
        .accessibilityAction(named: Text(L.A11y.favorite.localized)) { viewModel.toggleFavorite(sound) }
        .accessibilityAction(named: Text(L.Common.delete.localized)) { if !sound.isPreset { deleteSound(sound) } }
        // 왼쪽으로 밀기 → 즐겨찾기
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
            Button { viewModel.toggleFavorite(sound) } label: {
                Label(L.A11y.favorite.localized, systemImage: sound.isFavorite ? "star.slash.fill" : "star.fill")
            }
            .tint(DS.Colors.warm)
        }
        // 오른쪽으로 밀기 → 삭제(내 사운드만) + 편집
        .swipeActions(edge: .trailing, allowsFullSwipe: !sound.isPreset) {
            if !sound.isPreset {
                Button(role: .destructive) { deleteSound(sound) } label: {
                    Label(L.Common.delete.localized, systemImage: "trash")
                }
                Button { startEdit(sound) } label: {
                    Label(L.Common.edit.localized, systemImage: "slider.horizontal.3")
                }
                .tint(DS.Colors.accent)
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

// MARK: - Sound Name Card (썸네일 없는 심플 이름 카드)
/// 보관함 목록용 — 썸네일 대신 색 점 + 제목만. 즐겨찾기/프리셋 배지는 유지.
struct SoundNameCardView: View {
    let sound: CustomSound
    var viewModel: CustomSoundViewModel? = nil

    var body: some View {
        HStack(spacing: DS.Spacing.sm) {
            // 색 구분용 작은 점 (썸네일 대체)
            Circle()
                .fill(Color(hex: sound.color))
                .frame(width: 12, height: 12)

            Text(sound.title)
                .font(DS.Font.subhead().weight(.semibold))
                .foregroundColor(DS.Colors.textPrimary)
                .lineLimit(1)

            // 프리셋 배지
            if sound.isPreset {
                HStack(spacing: 3) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 8))
                    Text(L.Listen.presets.localized)
                        .font(DS.Font.caption().weight(.semibold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, DS.Spacing.xs)
                .padding(.vertical, 3)
                .background(Capsule().fill(DS.Colors.accent.opacity(0.95)))
            }

            Spacer(minLength: DS.Spacing.xs)

            // 즐겨찾기
            if let vm = viewModel {
                Button(action: { vm.toggleFavorite(sound) }) {
                    Image(systemName: sound.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(sound.isFavorite ? DS.Colors.danger : DS.Colors.textTertiary)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, DS.Spacing.md)
        .padding(.vertical, DS.Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DS.Colors.surface)
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


// MARK: - Gesture Coachmark (첫 실행 1회 제스처 안내)

struct GestureCoachmark: View {
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture { onDismiss() }

            VStack(spacing: DS.Spacing.lg) {
                Text("이렇게 사용해요")
                    .font(DS.Font.title())
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: DS.Spacing.md) {
                    row("hand.tap.fill", "탭하면 재생 / 일시정지")
                    row("arrow.left.and.right", "좌우로 밀면 다른 소리")
                    row("arrow.up", "위로 밀면 수면 타이머")
                    row("arrow.down", "아래로 밀면 보관함")
                }

                Button(action: onDismiss) {
                    Text("시작하기")
                        .font(DS.Font.headline())
                        .foregroundColor(DS.Colors.onAccent)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, DS.Spacing.sm)
                        .background(Capsule().fill(DS.Colors.accent))
                }
                .padding(.top, DS.Spacing.xs)
            }
            .padding(DS.Spacing.xl)
            .background(
                RoundedRectangle(cornerRadius: DS.Radius.xl, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal, DS.Spacing.xl)
        }
    }

    @ViewBuilder
    private func row(_ icon: String, _ text: String) -> some View {
        HStack(spacing: DS.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(DS.Colors.accent)
                .frame(width: 34, height: 34)
                .background(Circle().fill(Color.white.opacity(0.12)))
            Text(text)
                .font(DS.Font.callout())
                .foregroundColor(.white)
            Spacer(minLength: 0)
        }
    }
}

// MARK: - Starfield (우주를 여행하듯 천천히 흐르는 별)

struct Starfield: View {
    private let count = 64
    private func frac(_ v: Double) -> Double { v - floor(v) }

    var body: some View {
        // TimelineView + Canvas: 별 수십 개를 매 프레임 한 번에 그려 가볍게 애니메이션
        TimelineView(.animation) { tl in
            let t = tl.date.timeIntervalSinceReferenceDate
            Canvas { ctx, size in
                for i in 0..<count {
                    let fi = Double(i)
                    let bx = frac(sin(fi * 12.9898) * 43758.5453)
                    let by = frac(sin(fi * 78.233) * 12543.1234)
                    let sz = 0.7 + frac(sin(fi * 3.71) * 991.7) * 2.3
                    let baseOp = 0.12 + frac(sin(fi * 5.13) * 311.1) * 0.5
                    // 깊이감(시차): 큰(가까운) 별일수록 빠르게 아래로 흐름
                    let speed = 0.006 + frac(sin(fi * 9.17) * 517.3) * 0.030
                    let y = frac(by + t * speed) * size.height
                    let x = bx * size.width
                    // 은은한 반짝임
                    let tw = 0.7 + 0.3 * sin(t * 1.4 + fi)
                    let rect = CGRect(x: x, y: y, width: sz, height: sz)
                    ctx.fill(Path(ellipseIn: rect), with: .color(.white.opacity(baseOp * tw)))
                }
            }
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Haptics (가벼운 촉각 피드백 — 휴식 앱답게 은은하게)

enum Haptics {
    static func soft()      { UIImpactFeedbackGenerator(style: .soft).impactOccurred() }
    static func light()     { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func selection() { UISelectionFeedbackGenerator().selectionChanged() }
    static func success()   { UINotificationFeedbackGenerator().notificationOccurred(.success) }
}
