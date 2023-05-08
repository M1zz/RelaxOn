//
//  RelaxView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct RelaxView: View {
    
    @ObservedObject var timeData = Time()
    @State private var hours : [Int] = Array(0...23)
    @State private var minutes : [Int] = Array(0...59)
    @State var isShowingListenListView: Bool = false
    @State var isShowingTimerProgressView: Bool = false
    @State var progress: Double = 0.5
    
    var body: some View {
        VStack{
            
            Text("Timer")
                .font(.system(size: 24))
                .bold()
                .offset(x: -130, y: -100)
            
            if isShowingTimerProgressView == false {
                HStack{
                    Picker("select time", selection: $timeData.selectedTimeIndexHours, content: {
                        ForEach(hours, id: \.self) {
                            index in
                            Text("\(hours[index])").tag(index)
                                .font(.system(size: 25))
                        }
                    })
                    .pickerStyle(.wheel)
                    .frame(width: 75)
                    .clipped()
                    
                    Text("hours")
                    
                    Picker("select time", selection: $timeData.selectedTimeIndexMinutes, content: {
                        ForEach(minutes, id: \.self) {
                            index in
                            Text("\(minutes[index])").tag(index)
                                .font(.system(size: 25))
                        }
                    })
                    .pickerStyle(.wheel)
                    .frame(width: 75)
                    .clipped()
                    
                    Text("min")
                }.frame(width: 300, height: 300)
            } else {
                TimerProgressView(isShowingTimerProgressView: isShowingTimerProgressView, progress: $progress)
            }
            
            Button {
                isShowingListenListView.toggle()
            } label: {
                HStack{
                    Text("나만의 소리를 선택해주세요")
                        .foregroundColor(.white)
                        .padding(15)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding(17)
                }
            }
            .sheet(isPresented: $isShowingListenListView) {
                ListenListView()
            }
            .frame(width: 300, height: 50, alignment: .center)
            .background(Color("SystemGrey2"))
            .cornerRadius(10)
            .padding(30)
            
            HStack{
                Button {
                    isShowingTimerProgressView = false
                } label: {
                    ZStack {
                        Text("Reset")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(width: 70, height: 70)
                            .background(Color("SystemGrey2"))
                            .cornerRadius(50)
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 60, height: 60)
                    }}
                .padding(15)
                
                Spacer()
                
                Button {
                    isShowingTimerProgressView = true
                } label: {
                    if isShowingTimerProgressView == false {
                        ZStack {
                            Text("Start")
                                .fontWeight(.medium)
                                .foregroundColor(.purple)
                                .frame(width: 70, height: 70)
                                .background(Color("RelaxDimPurple"))
                                .cornerRadius(50)
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 60, height: 60)
                        }
                    }else {
                        ZStack {
                            Text("Pause")
                                .fontWeight(.medium)
                                .foregroundColor(.purple)
                                .frame(width: 70, height: 70)
                                .background(Color("RelaxDimPurple"))
                                .cornerRadius(50)
                            Circle()
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 60, height: 60)
                        }
                    }
                }
                .padding(15)
                
            }.frame(width: 300, height: 50, alignment: .center)
        }
    }
}

struct RelaxView_Previews: PreviewProvider {
    static var previews: some View {
        RelaxView()
    }
}
