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
            
            //Title
            Text("Timer")
                .font(.system(size: 24))
                .bold()
                .offset(x: -130, y: -100)
            
            if isShowingTimerProgressView == false {
                HStack{
                    //시간 피커
                    Picker("select time", selection: $timeData.selectedTimeIndexHours, content: {
                        
                        ForEach(0..<24, content: {
                            index in
                            Text("\(hours[index])").tag(index)
                                .font(.system(size: 25))
                        })
                    })
                    .pickerStyle(.wheel)
                    .frame(width: 75)
                    .clipped()
                    
                    //시간 단위
                    Text("hours")
                    
                    //분 피커
                    Picker("select time", selection: $timeData.selectedTimeIndexMinutes, content: {
                        
                        ForEach(0..<60, content: {
                            index in
                            Text("\(minutes[index]) ").tag(index)
                                .font(.system(size: 25))
                        })
                        
                    })
                    .pickerStyle(.wheel)
                    .frame(width: 75)
                    .clipped()
                    
                    // 분 단위
                    Text("min")
                }.frame(width: 300, height: 300)
            } else {
                TimerProgressView(isShowingTimerProgressView: isShowingTimerProgressView, progress: $progress)
            }
            
            // TODO: 3) 플레이 리스트 뷰 - 플레이 리스트 버튼을 누르는 경우 모달 프레젠트
            //Sound Select Button
            Button {
                isShowingListenListView.toggle()
            } label: {
                HStack{
                    Text("당신의 소리를 선택해주세요")
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
                //Reset Button
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
                
                //Start Button
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
