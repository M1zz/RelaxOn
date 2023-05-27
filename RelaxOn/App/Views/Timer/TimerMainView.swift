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
    
    @ObservedObject var timerManager = TimerManager()
    @State private var hours : [Int] = Array(0...23)
    @State private var minutes : [Int] = Array(0...59)
    @State var isShowingListenListView: Bool = false
    @State var isShowingTimerProgressView: Bool = false
    @State var progress: Double = 1.0
    
    var body: some View {
        VStack{
            HStack {
                Text("Timer")
                    .font(.largeTitle)
                    .padding()
                    .bold()
                Spacer()
            }
            
            Spacer()
            
            VStack {
                if isShowingTimerProgressView == false {
                    // TimePicker
                    HStack(alignment: .center){
                        Picker("select time", selection: $timerManager.selectedTimeIndexHours, content: {
                            ForEach(hours, id: \.self) {
                                index in
                                Text("\(hours[index])").tag(index)
                            }
                        })
                        .pickerStyle(.wheel)
                        .padding()
                        .clipped()
                        
                        Text("hours")
                        
                        Picker("select time", selection: $timerManager.selectedTimeIndexMinutes, content: {
                            ForEach(minutes, id: \.self) {
                                index in
                                Text("\(minutes[index])").tag(index)
                            }
                        })
                        .pickerStyle(.wheel)
                        .padding()
                        .clipped()
                        
                        Text("min")
                            .padding()
                    }
                    .padding()
                } else {
                    TimerProgressView(timerManager: timerManager)
                }
            }.padding(.horizontal, 10)
            Spacer()
            
            Button {
                isShowingListenListView.toggle()
            } label: {
                HStack{
                    Text("나만의 소리를 선택해주세요")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .sheet(isPresented: $isShowingListenListView) {
                ListenListView()
            }
            .background(Color.systemGrey2)
            .cornerRadius(10)
            .padding(20)
            
            Spacer(minLength: 50)
            
            HStack{
                Spacer()
                Button {
                    timerManager.stopTimer(timerManager: timerManager)
                    isShowingTimerProgressView = false
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.systemGrey3)
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .padding(10)
                        Text("Reset")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                    }
                }
                
                Spacer(minLength: 180)
                
                Button {
                    isShowingTimerProgressView = true
                } label: {
                    if isShowingTimerProgressView == false {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.relaxDimPurple)
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                                .padding(10)
                            Text("Start")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }else {
                        ZStack {
                            Circle()
                                .foregroundColor(Color.relaxDimPurple)
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                                .padding(10)
                            Text("Pause")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                        }
                    }
                }
                Spacer(minLength: 10)
            }.padding()
            Spacer(minLength: 50)
        }
    }
    
    
    struct RelaxView_Previews: PreviewProvider {
        static var previews: some View {
            TimerMainView()
        }
    }
}
