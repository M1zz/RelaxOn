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
            Spacer()
            if timerManager.isOn {
                TimerProgressBarView()
            } else {
                timePickerView()
            }
            Spacer()
            timerSettingButton()
        }
        .navigationBarTitleDisplayMode(.large)
        .background(Color.relaxBlack)
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
        } label: {
            Text("START")
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
