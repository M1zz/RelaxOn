<<<<<<< HEAD
<h1 align="center">
    <img style="height:50px; vertical-align:middle; border-radius:15px;" src="https://is2-ssl.mzstatic.com/image/thumb/Purple122/v4/32/48/ad/3248ad23-c180-5966-f7a0-a595121c3901/AppIcon-1x_U007emarketing-0-10-0-85-220.png/3000x0w.webp"/> LullabyRecipe iOS
</h1>

[![Swift Version][swift-image]](https://swift.org/)
[![Platform][Platform-image]](https://developer.apple.com/kr/ios/)
![Version][Version-image]

[swift-image]:https://img.shields.io/badge/swift-5.6-orange.svg?style=flat
[Platform-image]: https://img.shields.io/badge/Platform-ios-lightgray.svg?style=flat
[Version-image]: https://img.shields.io/badge/Version-1.0.3-231363.svg?style=flat

App Store: [Lullaby Recipe](https://apps.apple.com/kr/app/lullaby-recipe/id1626715109)  

<p>
  <img width="180" alt="스크린샷1" src="https://user-images.githubusercontent.com/81131715/178465919-b73defbb-498c-4efe-af6e-be09a382250d.png">
  &nbsp;&nbsp;
  <img width="180" alt="스크린샷1" src="https://user-images.githubusercontent.com/81131715/178465975-a78ffae7-b9a9-40e0-b092-396cef6cf29d.png">
  &nbsp;&nbsp;
  <img width="180" alt="스크린샷1" src="https://user-images.githubusercontent.com/81131715/178466053-677e976a-c613-4858-b1d0-a1b1ab1312ee.png">
  &nbsp;&nbsp;
  <img width="180" alt="스크린샷1" src="https://user-images.githubusercontent.com/81131715/178466061-c4dec397-b179-49e4-82ac-152b925379da.png">
</p>

## App Description
```
- Select and blend three kinds of sounds: Base, Melody, and Natural.
(For Base and Melody, it is recommended to choose only one for each.)

- Name your mix for different purposes. You can listen to your own music for better sleep, meditation, study, work, and more.

- Control the volume of each sound to get the best mix.
```

## Usage
<p align="center">
  <img width="300" alt="스크린샷1" src="https://user-images.githubusercontent.com/81131715/178482812-6def6b5e-7120-4287-adc1-a3800e60adde.gif">
</p>


## Project Structure
```
LullabyRecipe
├── Assets // Project Assets
├── ContentView.swift
├── Info.plist
├── Launch Screen.storyboard
├── LullabyRecipeApp.swift
├── Manager
│   ├── AudioManager.swift
│   └── UserDefaultsManager.swift
├── Model
│   ├── DummyData.swift
│   ├── MixedSound.swift
│   ├── Recipe.swift
│   └── Sound.swift
├── Resource // Music Resource
├── Utilities
│   └── Static.swift
└── Views
    ├── CustomTabView.swift
    ├── Home
    │   ├── Home.swift
    │   ├── MixedSoundCard.swift
    │   └── Music
    │       ├── Music.swift
    │       ├── MusicViewModel.swift
    │       └── VolumeControl.swift
    ├── Kitchen
    │   ├── CustomAlert.swift
    │   ├── Kitchen.swift
    │   └── SoundCard.swift
    ├── Onboarding
    │   └── OnBoarding.swift
    └── WhiteTitleText.swift
```

# Release Note
[Release Note](/release-note.md)
=======
# RelaxOn
내 손으로 만드는 ASMR

<div align="center">
  <img width=300 src="https://github.com/M1zz/RelaxOn/assets/108422901/15b96ad4-7a3a-41b2-a54f-b15b8a6fee28">
  <img width=300 src="https://github.com/M1zz/RelaxOn/assets/108422901/68b4af29-eb06-4739-b848-dba907a3c20f">
</div>
<div align="center">
  <img width=300 src="https://github.com/M1zz/RelaxOn/assets/108422901/9f3fe328-fbd6-4a24-88ee-f445292707c7">
  <img width=300 src="https://github.com/M1zz/RelaxOn/assets/108422901/c851de4c-5594-425a-87cc-94d39d7870b3">
  <img width=300 src="https://github.com/M1zz/RelaxOn/assets/108422901/bb065671-745d-4d6a-a749-290e86cfe049">
</div>

## AppStore Link 🔗
[‎Relax On - 수면 백색 소음 & 자연의 소리](https://apps.apple.com/kr/app/relax-on-수면-백색-소음-자연의-소리/id1626715109)

## Project Description 👩‍🏫
“더 이상 수면에 도움되는 소리를 찾지 말고 Relax On과 함께 만들어보세요.“

몇 번의 탭만으로 재생 목록에서 원하는 소리를 선택하고,
타이머를 설정하여 소리가 서서히 사라지도록 하여 깊은 잠에 빠져들 수 있으며,
상쾌한 기분으로 하루를 시작할 준비를 할 수 있습니다.

## Duration 🗓️
2023.03 ~

## Member 👨‍💻
ProjectManager - 2명
Design - 1명
iOS Mento - 1명
iOS - 2명

## Architecture 🏰
MVVM

## Tech Stack 🔨
- SwiftUI
- Combine
- AVFoundation
>>>>>>> renew
