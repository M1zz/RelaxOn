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
    
    @State var pageNumber = 0
    private let onboarding = [OnboardItem(imageName:OnboardInfo.IconName.lamp.rawValue,
                                          description:OnboardInfo.IconText.lamp.rawValue),
                              OnboardItem(imageName:OnboardInfo.IconName.equalizerbutton.rawValue,
                                          description: OnboardInfo.IconText.equlizerbutton.rawValue),
                              OnboardItem(imageName: OnboardInfo.IconName.musicplayer.rawValue,
                                          description: OnboardInfo.IconText.musicplayer.rawValue),
                              OnboardItem(imageName: OnboardInfo.IconName.headphone.rawValue,
                                          description: OnboardInfo.IconText.headphone.rawValue)]
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $pageNumber) {
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
                if pageNumber < onboarding.count - 1 { self.pageNumber += 1
                    print(pageNumber)
                } else {
                    // TODO: TutorialView로 이동
                }
            } label: {
                Text(pageNumber == 3 ? "시작하기" : "계속")
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
