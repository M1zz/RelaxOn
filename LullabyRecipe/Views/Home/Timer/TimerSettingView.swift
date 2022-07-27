//
//  TimerSettingView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI

struct TimerSettingView: View {
    // TODO: @State var를 타이머 뷰모델로 교체 예정
    @State var seconds: Double = 0

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

extension TimerSettingView {
    
    @ViewBuilder
    func timePickerView() -> some View {
        TimePickerView(seconds: $seconds)
            .environment(\.colorScheme, .dark) // 흰새 글씨로 바뀜
            .background(.black)
    }
    
    @ViewBuilder
    func timerSettingButton() -> some View {
        Button {
        // TODO: 타이머 모델에 값 넣는 함수 넣기
        } label: {
            Text("타이머 설정하기")
                .font(.system(size: 17, weight: .medium))
                .frame(width: deviceFrame().exceptPaddingWidth - 80, height: 44)
                .background(.secondary)
                .cornerRadius(8)
        }.buttonStyle(.plain)
    }
}
