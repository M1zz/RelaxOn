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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: CustomSoundViewModel

    let isTutorial: Bool
    @State var progress: Double = 0.0
    @State var isShowingSheet: Bool = false
    @State var originalSound: OriginalSound

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
                        if viewModel.isPlaying {
                            viewModel.stopSound()
                        }
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
                SoundSaveView(originalSound: originalSound)
            }
            
            // MARK: - Life Cycle
            .onAppear() {
                viewModel.sound = originalSound
                if !isTutorial {
                    viewModel.play(with: viewModel.sound)
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
            CircularSlider(type: .xSmall, imageName: featureIcon[0], isOnDrag: true, range: viewModel.intervalRange) { angle in
                viewModel.interval = Float(angle)
            }
            CircularSlider(type: .small, imageName: featureIcon[1], isOnDrag: true, range: viewModel.volumeRange) { angle in
                viewModel.volume = Float(angle)
            }
            CircularSlider(type: .medium, imageName: featureIcon[2], isOnDrag: true, range: viewModel.pitchRange) { angle in
                viewModel.pitch = Float(angle)
            }
            CircularSlider(type: .large, imageName: featureIcon[3], isOnDrag: false, range: viewModel.filterRange) { angle in
            }
        }
        .padding(24)
    }
    
    @ViewBuilder
    func backgroundCircle() -> some View {
        
        ZStack {
            Circle()
                .fill(Color(.CircularSliderBackground))
                .frame(width: 300)
            
            Circle()
                .stroke(style: .init(lineWidth: 1))
                .foregroundColor(Color(.CircularSliderLine))
                .frame(width: 80)
            
            Image(FeatureIcon.headset.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 26)
            
            ForEach(CircleType.all) { type in
                Circle()
                    .stroke(style: .init(lineWidth: 1))
                    .foregroundColor(Color(.CircularSliderLine))
                    .frame(width: type.width)
            }
            
            ForEach(0..<pointAngle.count, id: \.self) { index in
                Circle()
                    .frame(width: 6)
                    .foregroundColor(Color(.CircularSliderLine))
                    .offset(x: 300 / 2)
                    .rotationEffect(Angle(degrees: pointAngle[index]))
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
