//
//  OnBoarding.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/28.
//

import SwiftUI

struct OnBoarding: View {
    
    @State var userName: String = ""
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            ColorPalette.launchbackground.color.ignoresSafeArea()
            
            Image(ImageName.BackPattern.imageName)
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment:.leading) {
                WhiteTitleText(title: "Nice to meet you.")
                    .padding(.leading)
                
                WhiteTitleText(title: "What's your name?")
                    .padding(.leading)
                
                TextField("", text: $userName)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           maxHeight: 70)
                    .background(ColorPalette.background.color)
                    .cornerRadius(14)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(10)

                Button {
                    if userName.isEmpty {
                        // todo : 이름을 입력해주세요
                    } else {
                        UserDefaultsManager.shared.standard.set(true, forKey: UserDefaultsManager.shared.notFirstVisit)
                        UserDefaultsManager.shared.standard.set(userName, forKey: UserDefaultsManager.shared.userName)
                        showOnboarding = false
                    }
                } label: {
                    Text("Start")
                        .bold()
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               maxHeight: 50)
                        .font(Font.system(size: 22))
                        .foregroundColor(ColorPalette.forground.color)
                        .padding(.top, 10)
                }
            }
        }
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding(showOnboarding: .constant(true))
    }
}
