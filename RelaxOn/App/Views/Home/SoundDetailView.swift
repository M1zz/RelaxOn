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
    @State var progress: Double = 0.0
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
                soundController()
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
                SoundSaveView(originalSound: originalSound, audioVariation: AudioVariation(volume: viewModel.volume, pitch: viewModel.pitch, speed: viewModel.speed), audioFilter: originalSound.filter)
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
    
    @ViewBuilder
    func soundController() -> some View {
        ZStack {
            backgroundCircle()
            preCircularSliderView(type: .xSmall, imageName: featureIcon[0], gestureType: true, range: viewModel.intervalRange, in: Int(0.5)...5) { angle in
                viewModel.speed = Float(angle)
                print("IntervalSpeed : \(angle)")
            }
            preCircularSliderView(type: .small, imageName: featureIcon[1], gestureType: true, range: viewModel.volumeRange, in: 0...1) { angle in
                viewModel.volume = Float(angle)
                print("Volume : \(angle)")

            }
            preCircularSliderView(type: .medium, imageName: featureIcon[2], gestureType: true, range: viewModel.pitchRange, in: -25...25) { angle in
                viewModel.pitch = Float(angle)
                print("Pitch : \(angle)")
            }
            preCircularSliderView(type: .large, imageName: featureIcon[3], gestureType: false, range: viewModel.filterRange, filter: viewModel.selectedSound?.filter ?? .WaterDrop, in: 0...360) { angle in
                print("Filter : \(angle)")
            }
            
        }
        .padding(24)
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
            
            ForEach(CircleType.all) { type in
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(.relaxDimPurple)
                    .frame(width: type.width)
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
            .environmentObject(CustomSoundViewModel())
    }
}
