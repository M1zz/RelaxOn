import SwiftUI

struct RelaxView: View {
    
    @EnvironmentObject var timeData: Time
    @State private var hours : [Int] = Array(1...24)
    @State private var minutes : [Int] = Array(0...59)
    @State var isShowingListenListView: Bool = false
    @State var isShowingTimerProgressView: Bool = false
    
    
    var body: some View {
        
        VStack{
            
            //Title
            Text("Timer")
                .font(.system(size: 30))
                .bold()
                .offset(x: -100, y: -130)
            
            // TODO: 1) 타이머 세팅 뷰 - 타이머 세팅이 되어있지 않은 경우
            // TODO: 2) 타이머 뷰 - 타이머 세팅 되어있는 경우
            
            HStack{
                //시간
                Picker("select time", selection: $timeData.selectedTimeIndexHours, content: {
                    
                    ForEach(0..<24, content: {
                        index in
                        Text("\(minutes[index])").tag(index)
                            .font(.system(size: 25))
                    })
                })
                .pickerStyle(.wheel)
                .frame(width: 75)
                .clipped()
                
                //시간 단위
                Text("hours")
                    .bold()
                
                //minutes-Picker
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
                //Cancel Button
                Button {
                    
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
                }
                .padding(15)
                .fullScreenCover(isPresented: $isShowingTimerProgressView) {
                    TimerProgressView(isShowingTimerProgressView: isShowingTimerProgressView)
                }
            }.frame(width: 300, height: 50, alignment: .center)
        }
    }
    
    struct RelaxView_Previews: PreviewProvider {
        static var previews: some View {
            RelaxView()
                .environmentObject(Time())
        }
    }
}
