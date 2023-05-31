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
                    // TODO: 필터기능 구현
                    CircularSlider(width: circleWidth[3], imageName: featureIcon[3], gestureType: false, range: viewModel.filterRange) { angle in
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
                SoundSaveView(originalSound: originalSound, audioVariation: AudioVariation())
            }
            
            // MARK: - Life Cycle
            .onAppear() {
                if isTutorial == false {
                    viewModel.playSound(originSound: originalSound)
                }
            }
            .onDisappear() {
                if isTutorial == false {
                    viewModel.stopSound()
                }
            }
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(isTutorial: true, originalSound: OriginalSound(name: "물방울", filter: .waterDrop, category: .waterDrop, defaultColor: "DCE8F5"))
    }
}
