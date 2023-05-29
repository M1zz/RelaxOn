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
                    CircularSlider(width: circleWidth[0], imageName: featureIcon[0], gestureType: true) { angle in }
                    CircularSlider(width: circleWidth[1], imageName: featureIcon[1], gestureType: true) { angle in }
                    CircularSlider(width: circleWidth[2], imageName: featureIcon[2], gestureType: true) { angle in }
                    CircularSlider(width: circleWidth[3], imageName: featureIcon[3], gestureType: false) { angle in }
                    
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
            
            // MARK: - Life Cycle
            .onAppear() {
                if !viewModel.isPlaying {
                    viewModel.playSound(originSound: originalSound)
                }
            }
            .onDisappear() {
                if viewModel.isPlaying {
                    viewModel.stopSound()
                }
            }
            .fullScreenCover(isPresented: $isShowingSheet) {
                // TODO: 값을 넘겨주기 전에 변경된 값으로 AudioVariation 만들어서 보내야함
                SoundSaveView(originalSound: originalSound, audioVariation: AudioVariation())
            }
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(originalSound: OriginalSound(name: "물방울", filter: .WaterDrop, category: .waterDrop))
    }
}
