//
//  TimerSettingView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI

struct TimerSettingView: View {

    @State var seconds: Double = 0
    var timerManager = TimerManager.shared
    
    var body: some View {
        VStack {
            Spacer()
            timePickerView()
            Spacer()
            timerSettingButton()
        }
    }
}

// MARK: - PREVIEW
struct TimerSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSettingView()
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
            Text("타이머 설정하기")
                .font(.system(size: 17, weight: .medium))
                .frame(width: deviceFrame().exceptPaddingWidth - 80, height: 44)
                .background(.secondary)
                .cornerRadius(8)
        }.buttonStyle(.plain)
    }
}
