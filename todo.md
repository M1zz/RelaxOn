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

## 남은 작업 (수동 - 코드 아님)
- [ ] dev 브랜치 코드 변경 push / PR (원하면 진행)
- [ ] App Store Connect: App Description 또는 EULA 필드에 표준 약관 링크 추가
- [ ] App Store Connect: Privacy Policy 필드에 https://m1zz.github.io/RelaxOn/privacy.html 입력
- [ ] Guideline 2.3.3: 6.5"/5.5" iPhone 스크린샷을 최신 UI로 교체 (수동)
- [ ] Apple에 회신
