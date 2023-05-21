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
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            TabView(selection: $currentStep) {
                ForEach(0..<4) { num in
                    Image(onBoadingImageDark[num])
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea()
                }
            }.tabViewStyle(.page(indexDisplayMode: .never))
            
            Button {
                if currentStep < onBoadingImageDark.count - 1 { self.currentStep += 1
                    print(currentStep)
                } else {
                    // TODO: TutorialView로 이동
                }
            } label: {
                Text(currentStep == onBoadingImageDark.count - 1 ? "시작하기" : "계속")
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .bold()
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
