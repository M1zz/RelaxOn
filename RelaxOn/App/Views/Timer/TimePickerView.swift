//
//  TimePickerView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/27.
//

import SwiftUI

struct TimePickerView: View {
    @Binding var hours: [Int]
    @Binding var minutes: [Int]
    @Binding var selectedTimeIndexHours: Int
    @Binding var selectedTimeIndexMinutes: Int
    
    var body: some View {
        HStack {
            Spacer ()
            
            HStack(alignment: .center){
                Picker("Time Picker - hours", selection: $selectedTimeIndexHours, content: {
                    ForEach(hours, id: \.self) {
                        index in
                        Text("\(hours[index])").tag(index)
                    }
                })
                .pickerStyle(.wheel)
                
                Text("hours")
                    .font(.system(size: 23))
                    .padding(.horizontal, 10)
                
                Picker("Time Picker - minutes", selection: $selectedTimeIndexMinutes, content: {
                    ForEach(minutes, id: \.self) {
                        index in
                        Text("\(minutes[index])").tag(index)
                    }
                })
                .pickerStyle(.wheel)
                
                Text("min")
                    .font(.system(size: 23))
                    .padding(.horizontal, 10)
                
            }
            .frame(maxWidth: .infinity)
            .padding(20)

            Spacer ()
        }
    }
}


struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView(hours: .constant(Array(0...23)), minutes: .constant(Array(0...59)), selectedTimeIndexHours: .constant(1), selectedTimeIndexMinutes: .constant(1))
    }
}
