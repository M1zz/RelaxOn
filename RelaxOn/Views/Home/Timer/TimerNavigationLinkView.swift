//
//  TimerNavigatinoView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI

struct TimerNavigationLinkView: View {
    var body: some View {
        VStack(spacing: 6) {
            NavigationLink(destination : TimerSettingView()) {
                label
            }
            .navigationBarTitle("CD LIBRARY") // 백버튼 텍스트 내용
            .navigationBarHidden(true)
            .buttonStyle(.plain)
            Divider()
                .background(.white)
            HStack() {
                Text("Relax on as much as you want")
                    .font(.callout)
                    .foregroundColor(.white)
                Spacer()
            }
        }.padding(.horizontal, 20)
    }
    
    var label: some View {
        HStack(alignment: .bottom) {
            Text("Relax for")
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.systemGrey1)
                .padding(.bottom, 2)
            Spacer()
            Text("30")
                .font(.system(size: 28, weight: .regular))
                .foregroundColor(.relaxDimPurple)
            Text("min")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.relaxDimPurple)
                .padding(.bottom, 3)
            Image(systemName: "chevron.forward")
                .font(.system(size: 25))
                .foregroundColor(.relaxDimPurple)
                .opacity(0.6)
                .padding(.bottom, 3)
        }
    }
}

// MARK: - PREVIEW
struct TimerNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerNavigationLinkView()
            .background(.black)
        }
    }
}
