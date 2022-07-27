//
//  TimerNavigatinoView.swift
//  LullabyRecipe
//
//  Created by hyo on 2022/07/27.
//

import SwiftUI

struct TimerNavigationView: View {
    var body: some View {
        HStack(alignment: .bottom) {
            Text("HOW LONG ..")
                .font(.system(size: 24, weight: .medium))
                .padding(.bottom, 2)
            Spacer()
            Text("30")
                .font(.system(size: 28, weight: .regular))
            Text("min")
                .font(.system(size: 18, weight: .regular))
                .opacity(0.5)
                .padding(.bottom, 3)
            Image(systemName: "chevron.forward")
                .font(.system(size: 25))
                .opacity(0.6)
                .padding(.bottom, 3)
        }.padding(.horizontal, 20)
            .buttonStyle(.plain)
        
    }
}

struct TimerNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLink(destination: EmptyView()) {
                TimerNavigationView()
            }.buttonStyle(.plain)
        }
    }
}
