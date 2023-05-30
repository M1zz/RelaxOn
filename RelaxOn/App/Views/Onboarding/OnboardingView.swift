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
    
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @EnvironmentObject var appState: AppState
    
    @State private var pageNumber = 0
    @State private var showTutorial: Bool = false
    @Binding var isFirstVisit: Bool
    
    private let onboardingItems = OnboardItem.getAll()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $pageNumber) {
                ForEach(onboardingItems.indices, id: \.self) { index in
                    VStack {
                        Image(onboardingItems[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 80)
                        
                        Text(onboardingItems[index].description)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 50)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            VStack(spacing: 10) {
                HStack {
                    ForEach(onboardingItems.indices, id: \.self) { index in
                        Circle()
                            .frame(width: 7, height: 7)
                            .foregroundColor(pageNumber == index ? Color(.SelectedPage) : Color(.UnselectedPage))
                    }
                }
                
                Button {
                    if pageNumber < onboardingItems.count - 1 {
                        pageNumber += 1
                    } else {
                        showTutorial = true
                    }
                } label: {
                    Text(pageNumber == onboardingItems.count - 1 ? "시작하기" : "계속")
                        .bold()
                        .padding(14)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color(.PrimaryPurple))
                        .cornerRadius(12)
                        .padding(30)
                }
            }
            
            if showTutorial {
                TutorialView(isFirstVisit: $isFirstVisit)
            }
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isFirstVisit: .constant(true))
    }
}
