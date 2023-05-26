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
                    
                    Circle()
                        .frame(width: 300)
                        .foregroundColor(Color("SystemGrey1"))
                    
                    // TODO: 슬라이더 총 4개 필요
                    // TODO: 각 슬라이더의 기능별 이미지 추가
                    // TODO: 예시 - Slider(value: $viewModel.speed, in: 0.0...1.0, step: 0.1)
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
                viewModel.playSound(originSound: originalSound)
            }
            .onDisappear() {
                viewModel.stopSound()
            }
        }
    }
}

struct SoundDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(originalSound: OriginalSound(name: "물방울", filter: .waterDrop, category: .waterDrop, defaultColor: "DCE8F5"))
    }
}
