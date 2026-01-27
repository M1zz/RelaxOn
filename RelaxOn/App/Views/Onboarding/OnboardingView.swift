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
    @Binding var isFirstVisit: Bool

    private let onboardingItems = OnboardItem.getAll()

    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.1, green: 0.05, blue: 0.15),
                    Color(red: 0.15, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.15, blue: 0.25)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단 스킵 버튼
                HStack {
                    Spacer()
                    if pageNumber < onboardingItems.count - 1 {
                        Button(action: {
                            isFirstVisit = false
                        }) {
                            Text(L.Onboarding.skip.localized)
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                        }
                    }
                }
                .padding(.top, 50)

                // 메인 컨텐츠
                TabView(selection: $pageNumber) {
                    ForEach(onboardingItems.indices, id: \.self) { index in
                        GeometryReader { geo in
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 30) {
                                    Spacer(minLength: 20)

                                    // 이미지
                                    Image(onboardingItems[index].imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: geo.size.height * 0.4)
                                        .padding(.horizontal, 60)

                                    // 텍스트
                                    VStack(spacing: 16) {
                                        Text(getTitleForPage(index))
                                            .font(.system(size: 26, weight: .bold))
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .fixedSize(horizontal: false, vertical: true)

                                        Text(onboardingItems[index].description.localized)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white.opacity(0.7))
                                            .multilineTextAlignment(.center)
                                            .lineSpacing(6)
                                            .padding(.horizontal, 40)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }

                                    Spacer(minLength: 20)
                                }
                                .frame(minHeight: geo.size.height)
                            }
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // 하단 영역
                VStack(spacing: 24) {
                    // 페이지 인디케이터
                    HStack(spacing: 8) {
                        ForEach(onboardingItems.indices, id: \.self) { index in
                            if pageNumber == index {
                                Capsule()
                                    .fill(Color(.PrimaryPurple))
                                    .frame(width: 24, height: 8)
                            } else {
                                Circle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }

                    // 버튼
                    Button {
                        if pageNumber < onboardingItems.count - 1 {
                            withAnimation {
                                pageNumber += 1
                            }
                        } else {
                            isFirstVisit = false
                        }
                    } label: {
                        Text(pageNumber == onboardingItems.count - 1 ? L.Onboarding.start.localized : L.Onboarding.next.localized)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(.PrimaryPurple),
                                        Color(.PrimaryPurple).opacity(0.8)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color(.PrimaryPurple).opacity(0.4), radius: 12, x: 0, y: 6)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 50)
            }
        }
    }

    private func getTitleForPage(_ index: Int) -> String {
        switch index {
        case 0:
            return L.Onboarding.title1.localized
        case 1:
            return L.Onboarding.title2.localized
        case 2:
            return L.Onboarding.title3.localized
        case 3:
            return L.Onboarding.title4.localized
        default:
            return ""
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isFirstVisit: .constant(true))
    }
}
