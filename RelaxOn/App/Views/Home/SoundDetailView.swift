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
    let isTutorial: Bool
    @State var isShowingSheet: Bool = false
    @State var originalSound: OriginalSound
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("당신이 원하는 소리를 찾아가보세요")
                        .foregroundColor(Color(.Text))
                        .font(.system(size: 20, weight: .bold))
                        .padding(8)
                    Text("자유롭게 이동하며 실험해보세요")
                        .foregroundColor(Color(.Text))
                        .font(.system(size: 18, weight: .regular))
                }
                ZStack {
                    backgroundCircle()
                    CircularSlider(width: circleWidth[0], imageName: featureIcon[0], gestureType: true, range: viewModel.intervalRange) { angle in
                        print("간격 : \(angle)")
                        viewModel.speed = Float(1.0 - abs(angle * 0.00556))
                        
                    }
                    CircularSlider(width: circleWidth[1], imageName: featureIcon[1], gestureType: true, range: viewModel.volumeRange) { angle in
                        print("볼륨 : \(1.0 - abs(angle * 0.00556))")
                        viewModel.volume = Float((1.0 - abs(angle * 0.00556)))
                    }
                    CircularSlider(width: circleWidth[2], imageName: featureIcon[2], gestureType: true, range: viewModel.pitchRange) { angle in
                        print("높낮이 : \(angle * 13.4)")
                        viewModel.pitch = Float(angle * 13.4)
                    }

                    CircularSlider(width: circleWidth[3], imageName: featureIcon[3], gestureType: false, range: viewModel.filterRange, filter: viewModel.selectedSound?.filter ?? .WaterDrop) { angle in
                        print("필터 : \(angle)")
                        
                    }
                    
                }
                .padding(24)
            }
            
            .navigationBarTitle(originalSound.name, displayMode: .inline)
            .font(.system(size: 24, weight: .bold))
            
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color(.ChevronBack))
                            .frame(width: 30, height: 30)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("다음")
                            .foregroundColor(Color(.PrimaryPurple))
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            
            .fullScreenCover(isPresented: $isShowingSheet) {
                SoundSaveView(originalSound: originalSound, audioVariation: AudioVariation(volume: viewModel.volume, pitch: viewModel.pitch, speed: viewModel.speed), audioFilter: originalSound.filter, backgroundColor: originalSound.color)
            }
            
            // MARK: - Life Cycle
            .onAppear() {
                if !isTutorial {
                    viewModel.isPlaying = true
                    viewModel.playSound(originSound: originalSound)
                }
            }
            .onDisappear {
                if !isTutorial {
                    viewModel.stopSound()
                }
                presentationMode.wrappedValue.dismiss()
                
            }
        }
    }
    
    // 배경으로 쓰이는 원 + 원형 라인 + 이동 포인트
    @ViewBuilder
    func backgroundCircle() -> some View {
        
        ZStack {
            
            Circle()
                .fill(Color.relaxDimPurple)
                .frame(width: 300)
                .opacity(0.3)
            
            Circle()
                .stroke(style: .init(lineWidth: 1))
                .foregroundColor(.relaxDimPurple)
                .frame(width: 80)
            
            Image(FeatureIcon.headset.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 26)
            
            ForEach(0..<circleWidth.count, id: \.self) { index in
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(.relaxDimPurple)
                    .frame(width: circleWidth[index])
            }
            
            ForEach(0..<pointAngle.count, id: \.self) { index in
                Circle()
                    .frame(width: 6)
                    .foregroundColor(.purple)
                    .offset(x: 300 / 2)
                    .rotationEffect(.init(degrees: pointAngle[index]))
            }
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(isTutorial: true, originalSound: OriginalSound(name: "물방울", filter: .WaterDrop, category: .waterDrop))
    }
}
