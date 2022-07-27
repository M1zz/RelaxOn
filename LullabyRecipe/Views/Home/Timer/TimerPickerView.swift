//
//  TimerPickerView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI
import UIKit

struct TimePickerView: UIViewRepresentable {
    @Binding var date: Date

    func makeUIView(context: Context) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return datePicker
    }

    func updateUIView(_ datePicker: UIDatePicker, context: Context) {
        datePicker.date = date
    }

    func makeCoordinator() -> TimePickerView.Coordinator {
        Coordinator(date: $date)
    }

    class Coordinator: NSObject {
        private let date: Binding<Date>

        init(date: Binding<Date>) {
            self.date = date
        }

        @objc func changed(_ sender: UIDatePicker) {
            self.date.wrappedValue = sender.date
        }
    }
}

struct TimerPickerView_Previews: PreviewProvider {
    
    struct TimerPickerViewForPreview: View {
        @State var selectedDate = Date()
        var body: some View {
            VStack {
                Text("\(selectedDate)")
                TimePickerView(date: $selectedDate)
                    .environment(\.colorScheme, .dark) // 흰새 글씨로 바뀜
                    .background(.black)
            }
        }
    }
    
    static var previews: some View {
        TimerPickerViewForPreview()
    }
}
