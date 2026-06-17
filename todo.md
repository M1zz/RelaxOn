# TODO - App Store 리젝 대응 (Submission f68454b3)

## Guideline 3.1.2 - 구독 필수 정보 (코드 수정 완료)
- [x] 구독 화면에 개인정보처리방침(Privacy Policy) 기능 링크 추가
- [x] 구독 화면에 이용약관(Apple 표준 EULA) 기능 링크 추가
- [x] 구독 제목/기간/가격 표시 확인 (가격·체험 표시 기존 존재)
- [x] 로컬라이제이션 키 추가 (ko/en)
- [x] 자동 갱신 안내 문구 추가

## GitHub Pages 배포 (완료)
- [x] docs/index.html 지원 페이지 작성
- [x] docs/privacy.html 개인정보 처리방침 작성
- [x] main 브랜치에 docs push → Pages 빌드 완료(built)
- [x] URL 라이브 확인 (둘 다 HTTP 200)
  - 지원: https://m1zz.github.io/RelaxOn/
  - 개인정보: https://m1zz.github.io/RelaxOn/privacy.html
- [x] README에 지원/개인정보/약관 링크 추가

## 버전
- [x] 앱 버전 4.0.1 유지 (MARKETING_VERSION 변경 없음)

## 접근성 개선 (시각장애인 사용 / 구조 단순화) - 1차 완료
방향: 네이티브 컨트롤로 교체 + 핵심 플로우(듣기→재생→타이머→구독) 우선
- [x] ListenListView 헤더 아이콘 버튼 라벨 (저장목록/타이머+남은시간 값)
- [x] 캠프파이어/물방울 등 장식 비주얼 VoiceOver 숨김
- [x] 미니플레이어: 정보영역 1개 버튼으로 그룹화(전체플레이어 열기)+재생/일시정지 분리 라벨
- [x] SavedSoundsListView 사운드 카드 라벨·버튼 trait·재생 힌트·즐겨찾기 커스텀 액션
- [x] 추천 카드 버튼 trait·힌트
- [x] TimerView 피커 라벨, 남은시간 live region(updatesFrequently), 중지/일시정지 라벨
- [x] TimePickerView 휠 라벨 + 단위 텍스트 로컬라이즈
- [x] SubscriptionView 닫기 버튼 라벨 + 44pt 터치영역
- [x] SoundDetailView 네이티브 Slider 라벨·값(볼륨/간격/피치/변동폭), 필터 선택상태, 뒤로 버튼
- [x] SoundPlayerFullModalView 이전/재생/다음·공간음향 슬라이더 라벨·값
- [x] a11y 로컬라이제이션 키 36개(ko/en) 추가
- [x] 빌드 검증 (BUILD SUCCEEDED)
- 참고: DragCircularSlider/SnapCircularSlider는 미사용 레거시(실제 UI는 이미 네이티브 Slider)

### 접근성 - 2차 후보 (다음 단계)
- [ ] 온보딩 이미지 라벨/숨김, 페이지 인디케이터 정리
- [ ] CreateNewSoundView(사운드 제작) 칩/볼륨/미리듣기 접근성
- [ ] SettingsView 타이머 컨트롤 접근성
- [ ] Dynamic Type: 하드코딩 폰트(약 211곳) semantic 전환 (저시력자, 레이아웃 검증 필요)
- [ ] 미사용 레거시 파일 정리(DragCircularSlider/SnapCircularSlider, pbxproj 수정 필요)

## UI 전면 개편 (고요한 미니멀) - 1차 완료
방향: 고요한 미니멀 + 디자인 시스템부터 재구축, 라이트/다크 적응형
- [x] 디자인 시스템 구축: DesignSystem/Theme.swift(색/타이포/간격/라운드/그림자), Components.swift(ScreenBackground, dsCard, Primary/SecondaryButtonStyle, SectionHeader, DSChip, CircleIconButton)
- [x] pbxproj에 DesignSystem 그룹/파일 추가
- [x] 홈(Listen): 캠프파이어 → 브리딩 오브, 헤더/추천/미니플레이어/빈상태
- [x] 타이머 설정/진행 화면
- [x] 저장목록(카드/섹션/검색/빈상태)
- [x] 구독 화면(SubscriptionView)
- [x] 사운드 편집(SoundDetailView) - 슬라이더 카드
- [x] 전체 플레이어(SoundPlayerFullModalView)
- [x] 사운드 제작(CreateNewSoundView)
- [x] 사운드 저장(SoundSaveView)
- [x] 온보딩(OnboardingView)
- [x] 설정(SettingsView)
- [x] 타이머 사운드 선택(TimerSoundSelectModalView)
- [x] 타이머 원형 프로그레스 바 색상 정렬
- [x] 빌드 성공 + 시뮬레이터 스크린샷 확인(온보딩/홈)
- [x] 앱 버전 4.0.1 유지

### UI 개편 - 2차 후보
- [ ] 보조 컴포넌트 미세 조정(SoundThumbnailView, TimerSoundListCell, ListenListCell 등)
- [ ] Dynamic Type 전수 검증(이미 DS.Font는 semantic이라 대부분 확대 대응)
- [ ] 라이트/다크 모드 양쪽 실기기 점검
- [ ] 레거시 중복 파일 정리(Views/ 루트의 SoundListView/SoundSaveView/SoundSelectView, 미사용 슬라이더)

## 남은 작업 (수동 - 코드 아님)
- [ ] dev 브랜치 코드 변경 push / PR (원하면 진행)
- [ ] App Store Connect: App Description 또는 EULA 필드에 표준 약관 링크 추가
- [ ] App Store Connect: Privacy Policy 필드에 https://m1zz.github.io/RelaxOn/privacy.html 입력
- [ ] Guideline 2.3.3: 6.5"/5.5" iPhone 스크린샷을 최신 UI로 교체 (수동)
- [ ] Apple에 회신
