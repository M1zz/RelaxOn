//
//  SettingsView.swift
//  RelaxOn
//
//  Created by Claude on 2025/01/15.
//

import SwiftUI

/**
 설정 View
 타이머와 기타 설정을 포함
 */
struct SettingsView: View {

    @EnvironmentObject var viewModel: CustomSoundViewModel
    @ObservedObject var timerManager = TimerManager(viewModel: CustomSoundViewModel())
    @State private var hours : [Int] = Array(0...23)
    @State private var minutes : [Int] = Array(0...59)
    @State var isShowingSelectorView: Bool = false
    @State var isShowingTimerProgressView: Bool = false
    @State var progress: Double = 1.0

    var body: some View {

        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                // 타이틀
                Text(TabItems.settings.rawValue)
                    .foregroundColor(Color(.TitleText))
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)

                ScrollView {
                    VStack(spacing: 24) {
                        // 타이머 섹션
                        timerSection()

                        // 향후 다른 설정 추가 가능
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .onAppear {
            timerManager.viewModel = viewModel
            timerManager.timerDidFinish = {
                self.isShowingTimerProgressView = false
            }
        }
    }

    @ViewBuilder
    private func timerSection() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // 섹션 제목
            HStack {
                Image(systemName: "timer")
                    .font(.system(size: 18))
                    .foregroundColor(Color(.PrimaryPurple))
                Text("수면 타이머")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(.TitleText))
            }

            // 타이머 컨텐츠
            VStack(spacing: 20) {

                // 타이머 or 프로그레스
                if isShowingTimerProgressView == false {
                    TimePickerView(hours: $hours,
                                   minutes: $minutes,
                                   selectedTimeIndexHours: $timerManager.selectedTimeIndexHours,
                                   selectedTimeIndexMinutes: $timerManager.selectedTimeIndexMinutes)
                } else {
                    TimerProgressView(timerManager: timerManager)
                }

                // 사운드 선택 버튼
                Button {
                    isShowingSelectorView.toggle()
                } label: {
                    selectSoundButton()
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isShowingSelectorView) {
                    TimerSoundSelectModalView()
                        .presentationDetents([.fraction(0.88)])
                }

                // 컨트롤 버튼들
                HStack(spacing: 20) {
                    // 리셋 버튼
                    Button {
                        timerManager.stopTimer(timerManager: timerManager)
                        isShowingTimerProgressView = false
                    } label: {
                        if isShowingTimerProgressView {
                            Image(TimerButton.reset_activated.rawValue)
                                .resizable()
                                .frame(width: 70, height: 70)
                        } else {
                            Image(TimerButton.reset_deactivated.rawValue)
                                .resizable()
                                .frame(width: 70, height: 70)
                        }
                    }

                    Spacer()

                    // 시작/중단 버튼
                    Button {
                        if isShowingTimerProgressView {
                            if let timer = timerManager.textTimer {
                                if timer.isValid {
                                    timerManager.pauseTimer(timerManager: timerManager)
                                }
                            } else {
                                timerManager.resumeTimer(timerManager: timerManager)
                                if let sound = viewModel.selectedSound {
                                    viewModel.play(with: sound)
                                }
                            }
                        } else {
                            if let sound = viewModel.selectedSound {
                                viewModel.play(with: sound)
                            }
                            isShowingTimerProgressView = true
                        }
                    } label: {
                        if isShowingTimerProgressView == false {
                            Image(TimerButton.start_circle.rawValue)
                                .resizable()
                                .frame(width: 70, height: 70)
                        } else {
                            if let timer = timerManager.textTimer {
                                if timer.isValid {
                                    Image(TimerButton.pause_circle.rawValue)
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                }
                            } else {
                                Image(TimerButton.start_circle.rawValue)
                                    .resizable()
                                    .frame(width: 70, height: 70)
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            .padding(20)
            .background(Color(.CircularSliderBackground).opacity(0.3))
            .cornerRadius(16)
        }
    }

    @ViewBuilder
    private func selectSoundButton() -> some View {
        HStack {
            Text(viewModel.selectedSound?.title ?? "나만의 소리를 선택해주세요")
                .foregroundColor(Color(.TimerMyListText))

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Color(.TimerMyListText))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 15)
        .background(Color(.TimerMyListBackground))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(CustomSoundViewModel())
    }
}
