//
//  TimerSettingView.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI

struct TimerSettingView: View {

    @State var seconds: Double = UserDefaults.standard.double(forKey: "lastSetDurationInSeconds")
    var minute: Int {
        Int(seconds / 60)
    }
    
    @ObservedObject var timerManager = TimerManager.shared
    
    var body: some View {
        VStack {
            header
            Spacer()
            timePickerView()
            Spacer()
            timerSettingButton()
        }
        .navigationBarTitleDisplayMode(.large)
        .background(Color.relaxBlack)
    }
    
    var header: some View {
        return VStack(spacing: 6) {
            HStack(alignment: .bottom) {
                Text("Relax for")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.systemGrey1)
                    .padding(.bottom, 2)
                Spacer()
                Text("\(minute)")
                    .font(.system(size: 28, weight: .regular))
                    .foregroundColor(.relaxDimPurple)
                Text("min")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.relaxDimPurple)
                    .padding(.bottom, 3)
            }
            Divider().background(.white)
                .padding(.bottom, 5)
            HStack() {
                Text("After \(minute) minutes, Relax On will automatically end")
                    .font(.system(size: 16))
                    .foregroundColor(.systemGrey1)
                Spacer()
            }
        }.padding(.horizontal, 20)
    }
}

// MARK: - PREVIEW
struct TimerSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSettingView()
            .preferredColorScheme(.dark)
    }
}

// MARK: - component View
extension TimerSettingView {
    @ViewBuilder
    func timePickerView() -> some View {
        TimePicker(seconds: $seconds)
            .environment(\.colorScheme, .dark) // 흰새 글씨로 바뀜
            .background(.black)
    }
    
    @ViewBuilder
    func timerSettingButton() -> some View {
        Button {
            timerManager.start(countDownDuration: seconds)
            WidgetManager.setupTimerToLockScreendWidget(settedSeconds: seconds)
        } label: {
            Text("SAVE")
                .font(.system(size: 20, weight: .medium))
                .frame(width: deviceFrame.screenWidth - 40, height: Layout.SaveButton.height)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [.relaxNightBlue, .relaxLavender]),
                                           startPoint: .leading, endPoint: .trailing))
                .cornerRadius(4)
        }.buttonStyle(.plain)
    }
}

extension TimerSettingView {
    private struct Layout {
        enum SaveButton {
            static let height: CGFloat = 60
        }
    }
}
