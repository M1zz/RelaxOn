//
//  TimerMainView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

/**
 타이머 View
 타이머를 설정하기 전의 View
 설정한 시간만큼 특정 음원을 반복 재생하는 기능
 */
struct TimerMainView: View {
    
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @ObservedObject var timerManager = TimerManager()
    @State private var hours : [Int] = Array(0...23)
    @State private var minutes : [Int] = Array(0...59)
    @State var isShowingSelectorView: Bool = false
    @State var isShowingTimerProgressView: Bool = false
    @State var progress: Double = 1.0
    @State private var selectedSoundText: String = ""
    
    var body: some View {
        
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text(TabItems.timer.rawValue)
                    .foregroundColor(Color(.TitleText))
                    .font(.system(size: 24, weight: .bold))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 4)
                
                Spacer()
                
                VStack(spacing: 80) {
                    if isShowingTimerProgressView == false {
                        TimePickerView(hours: $hours,
                                       minutes: $minutes,
                                       selectedTimeIndexHours: $timerManager.selectedTimeIndexHours,
                                       selectedTimeIndexMinutes: $timerManager.selectedTimeIndexMinutes)
                    } else {
                        TimerProgressView(timerManager: timerManager)
                            .padding(.top, 60)
                    }
                    
                    VStack(spacing: 50) {
                        Button {
                            isShowingSelectorView.toggle()
                        } label: {
                            selectSoundButton()
                                .cornerRadius(10)
                                .padding(.horizontal, 38)
                        }
                        
                        .sheet(isPresented: $isShowingSelectorView) {
                            TimerSoundSelectModalView()
                                .presentationDetents([.fraction(0.88)])
                        }
                        
                        HStack {
                            Button {
                                timerManager.stopTimer(timerManager: timerManager)
                                isShowingTimerProgressView = false
                            } label: {
                                if isShowingTimerProgressView {
                                    Image("button_reset-activated")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                } else {
                                    Image("button_reset-deactivated")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                }
                            }
                            
                            Spacer ()
                            
                            Button {
                                if isShowingTimerProgressView {
                                    if let timer = timerManager.textTimer {
                                        if timer.isValid {
                                            timerManager.pauseTimer(timerManager: timerManager)
                                        }
                                    } else {
                                        timerManager.resumeTimer(timerManager: timerManager)
                                    }
                                }
                                isShowingTimerProgressView = true
                            } label: {
                                if isShowingTimerProgressView == false {
                                    Image("button_start")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                } else {
                                    if let timer = timerManager.textTimer {
                                        if timer.isValid {
                                            Image("button_pause")
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                        }
                                    } else {
                                        Image("button_resume")
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                    }
                                    
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func selectSoundButton() -> some View {
        HStack {
            Text(viewModel.selectedSound?.fileName ?? "나만의 소리를 선택해주세요")
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

struct RelaxView_Previews: PreviewProvider {
    static var previews: some View {
        TimerMainView()
    }
}

