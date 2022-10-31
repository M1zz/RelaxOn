//
//  MainView.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                #warning("TimerNavigationLinkView 들어가야함")
                HStack {
                    Text("CDLibrary")
                    Text("edit")
                }
                CDGridView()
               
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
