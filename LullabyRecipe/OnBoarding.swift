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
            ColorPalette.background.color.ignoresSafeArea()
            
            Image("BackPattern")
                .resizable()
                .ignoresSafeArea()
            
            VStack(alignment:.center) {
                WhiteTitleText(title: "Nice to meet you.")
                
                WhiteTitleText(title: "What's your name?")
                
                TextField("Username", text: $userName)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           maxHeight: 50)
                    .background(ColorPalette.background.color)
                    .cornerRadius(14)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(10)

                Button {
                    if userName.isEmpty {
                        // todo : 이름을 입력해주세요
                    } else {
                        UserDefaults.standard.set(true, forKey: "notFirstVisit")
                        UserDefaults.standard.set(userName, forKey: "userName")
                        showOnboarding = false
                    }
                } label: {
                    Text("start")
                        .bold()
                        .frame(minWidth: 0,
                               maxWidth: .infinity,
                               maxHeight: 50)
                        .font(Font.system(size: 22))
                        .foregroundColor(ColorPalette.forground.color)
                        .padding(.top, 20)
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
