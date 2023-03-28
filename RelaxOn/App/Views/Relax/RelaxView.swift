import SwiftUI

struct RelaxView: View {
    
    @State var timerTime: Double
    
    var body: some View {
        
        VStack{
            
            //Title
            Text("Relax Time")
                .font(.system(size: 30))
                .bold()
                .offset(x: -100, y: -130)
            
            // TODO: 1) 타이머 세팅 뷰 - 타이머 세팅이 되어있지 않은 경우
            // TODO: 2) 타이머 뷰 - 타이머 세팅 되어있는 경우
            //TimePiker
            TimePicker(seconds: $timerTime)
            
            // TODO: 3) 플레이 리스트 뷰 - 플레이 리스트 버튼을 누르는 경우 모달 프레젠트
            //Sound Select Button
            Button {
                
            } label: {
                HStack{
                    Text("Choose your relaxing sound")
                        .foregroundColor(.white)
                        .padding(15)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding(17)
                }
            }
            .frame(width: 300, height: 50, alignment: .center)
            .background(Color("SystemGrey2"))
            .cornerRadius(10)
            .padding(30)
            HStack{
                //Cancel Button
                Button {
                    
                } label: {
                    Text("Cancel")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 70, height: 70)
                        .background(Color("SystemGrey2"))
                        .cornerRadius(50)
                }
                .padding(15)
                
                Spacer()
                
                //Start Button
                Button {
                    
                } label: {
                    Text("Start")
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                        .frame(width: 70, height: 70)
                        .background(Color("RelaxDimPurple"))
                        .cornerRadius(50)
                }
                .padding(15)
                
            }.frame(width: 300, height: 50, alignment: .center)
        }
    }
}

struct RelaxView_Previews: PreviewProvider {
    static var previews: some View {
        RelaxView(timerTime: 50)
    }
}
