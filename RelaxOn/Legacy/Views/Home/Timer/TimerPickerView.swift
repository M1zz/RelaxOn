//
//  TimerPickerView.swift
//  RelaxOn
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI
import UIKit

struct TimePicker: UIViewRepresentable {
    @Binding var seconds: Double

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ datePicker: UIDatePicker, context: Context) {
        datePicker.countDownDuration = seconds
    }

    func makeCoordinator() -> TimePicker.Coordinator {
        Coordinator(seconds: $seconds)
    }

    final class Coordinator: NSObject {
        private let seconds: Binding<Double>

        init(seconds: Binding<Double>) {
            self.seconds = seconds
        }

        @objc func changed(_ sender: UIDatePicker) {
            self.seconds.wrappedValue = sender.countDownDuration
        }
    }
}

// MARK: - PREVIEW
struct TimePicker_Previews: PreviewProvider {
    
    struct TimePickerForPreview: View {
        @State var seconds = 60.0
        var body: some View {
            VStack {
                Text("\(seconds)")
                TimePicker(seconds: $seconds)
                    .environment(\.colorScheme, .dark) // 흰새 글씨로 바뀜
                    .background(.black)
            }
        }
    }
    
    static var previews: some View {
        TimePickerForPreview()
    }
}
