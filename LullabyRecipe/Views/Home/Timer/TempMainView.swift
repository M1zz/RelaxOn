//
//  TempMainView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI

struct TempMainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                NavigationLink(destination : TimerSettingView()) {
                    TimerNavigationView()
                }
                .navigationBarTitle("HOW LONG..")
                .navigationBarHidden(true)
                .buttonStyle(.plain)
                Spacer()
            }
        }
    }
}

struct TempMainView_Previews: PreviewProvider {
    static var previews: some View {
        TempMainView()
    }
}
