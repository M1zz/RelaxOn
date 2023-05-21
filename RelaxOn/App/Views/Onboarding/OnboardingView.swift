//
//  OnboardingView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

/**
 처음 시작하는 유저에게 보여지는
 온보딩 화면
 */

import SwiftUI

struct OnboardingView: View {
    
    @State var currentStep = 0
    private let onboarding = [OnboardItem(imageName:OnboardInfo.lamp.rawValue,
                                          description:OnboardInfo.lampText.rawValue),
                              OnboardItem(imageName:OnboardInfo.equalizerbutton.rawValue,
                                          description: OnboardInfo.equlizerbuttonText.rawValue),
                              OnboardItem(imageName: OnboardInfo.musicplayer.rawValue,
                                          description: OnboardInfo.musicplayerText.rawValue),
                              OnboardItem(imageName: OnboardInfo.headphone.rawValue,
                                          description: OnboardInfo.headphoneText.rawValue)]
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $currentStep) {
                ForEach(0..<4) { num in
                    VStack{
                        Image(onboarding[num].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 80)
                        Text(onboarding[num].description)
                            .frame(maxWidth:.infinity)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                        
                    }
                }
            }.tabViewStyle(.page(indexDisplayMode: .never))
            
            Button {
                if currentStep < onboarding.count - 1 { self.currentStep += 1
                    print(currentStep)
                } else {
                    // TODO: TutorialView로 이동
                }
            } label: {
                Text(currentStep == 3 ? "시작하기" : "계속")
                    .bold()
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.relaxDimPurple)
                    .cornerRadius(12)
                    .padding(30)
                
            }
        }.ignoresSafeArea()
    }
}
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
