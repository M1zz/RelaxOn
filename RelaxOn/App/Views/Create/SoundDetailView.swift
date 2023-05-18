//
//  SoundDetailView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI
import AVFoundation

/**
 사용자가 Sound를 커스텀하는 View
 */
struct SoundDetailView: View {
    
    // MARK: - Properties
    @State var isShowingSheet: Bool = false
    @State var originalSound: Sound
    @ObservedObject var audioManager = AudioManager()
    
    var body: some View {
        VStack {
            VStack {
                Text("당신이 원하는 소리를 찾아가보세요")
                    .foregroundColor(.black)
                    .font(.title2)
                    .padding(8)
                Text("자유롭게 이동하며 실험해보세요")
                    .foregroundColor(.black)
                    .font(.title3)
            }
            ZStack {
                
                Circle()
                    .frame(width: 300)
                    .foregroundColor(Color("SystemGrey1"))
                
                // TODO: 슬라이더 총 4개 필요
                // TODO: 각 슬라이더의 기능별 이미지 추가
                CircleSlider(width: 300)
                CircleSlider(width: 210)
                CircleSlider(width: 120)
                
                // TODO: 컬러 설정 변경 필요
                Circle()
                    .stroke(Color("SystemGrey2"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .frame(width: 80)
                
                // TODO: Figma에 있는 이미지와 다름 -> Figma와 동일한 이미지로 Asset 추가하고 변경 필요
                Image(systemName: "headphones")
                
            }
            .padding(24)
        }
        
        .navigationBarTitle(originalSound.name, displayMode: .inline)
        .font(.system(size: 24, weight: .bold))
        
        .toolbar {
            Button {
                print("tapped done button")
                isShowingSheet.toggle()
            } label: {
                Text("Done")
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 20))
            }
            
            .fullScreenCover(isPresented: $isShowingSheet) {
                SoundSaveView(mixedSound: MixedSound(
                    name: originalSound.name,
                    volume: audioManager.volume,
                    imageName: originalSound.imageName)
                )
            }
        }
        
        // MARK: - Life Cycle
        .onAppear() {
            audioManager.playAudio(sound: originalSound)
        }
        .onDisappear() {
            audioManager.stopAudio()
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(originalSound: Sound(name: "Water Drop"))
    }
}

/**
 원하는 width 크기만큼의 원형 슬라이더를 만드는 View 객체
 */
struct CircleSlider: View {

    @State var angle: Double = Double.random(in: 0...360)
    @State var width: CGFloat
    
    init(width: CGFloat) {
        self.width = width
    }
    
    var body: some View {

        VStack {
            ZStack {
                
                Circle()
                    .stroke(Color("SystemGrey2"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .frame(width: width)
                
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color("SystemGrey3"))
                    .offset(x: width / 2)
                    .rotationEffect(.init(degrees: angle))
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                            })
                    )
            }
        }
    }
    
    func onDrag(value: DragGesture.Value) {
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        withAnimation(Animation.linear(duration: 0.15)) {
            self.angle = Double(angle)
        }
    }
}
