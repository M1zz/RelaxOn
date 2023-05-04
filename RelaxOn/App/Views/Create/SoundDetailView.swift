//
//  SoundDetailView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI
import AVFoundation

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
                
                // width는 원하는 원의 크기
                CircleSlider(width: 300)
                CircleSlider(width: 210)
                CircleSlider(width: 120)
                
                Circle()
                    .stroke(Color("SystemGrey2"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .frame(width: 80)
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


struct CircleSlider: View {
    
    
    @State var angle: Double = Double(Int.random(in: 0..<361))
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
