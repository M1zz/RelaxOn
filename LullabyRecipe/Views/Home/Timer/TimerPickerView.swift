//
//  TimerPickerView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI
import UIKit

struct TimePickerView: UIViewRepresentable {
    @Binding var seconds: Double

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ datePicker: UIDatePicker, context: Context) {
    }

    func makeCoordinator() -> TimePickerView.Coordinator {
        Coordinator(seconds: $seconds)
    }

    class Coordinator: NSObject {
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
struct TimerPickerView_Previews: PreviewProvider {
    
    struct TimerPickerViewForPreview: View {
        @State var seconds = 0.0
        var body: some View {
            VStack {
                Text("\(seconds)")
                TimePickerView(seconds: $seconds)
                    .environment(\.colorScheme, .dark) // 흰새 글씨로 바뀜
                    .background(.black)
            }
        }
    }
    
    static var previews: some View {
        TimerPickerViewForPreview()
    }
}
