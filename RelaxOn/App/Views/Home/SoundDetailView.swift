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
    @State var originalSound: OriginalSound
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
            // TODO: 오디오 반복 재생
        }
        .onDisappear() {
            // TODO: 오디오 재생 멈춤
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(originalSound: OriginalSound(name: "물방울", filter: .waterDrop, imageName: "WaterDrop", defaultColor: "DCE8F5"))
    }
}
