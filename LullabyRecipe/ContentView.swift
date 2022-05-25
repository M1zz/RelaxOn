//
//  ContentView.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI

enum SelectedType: String {
    case home = "Home"
    case kitchen = "Kitchen"
}

struct ContentView: View {
    
    @State var selected: SelectedType = .home

    var body: some View {
        NavigationView {
            VStack {
                
                switch selected {
                case .home:
                    Home()
                case .kitchen:
                    Kitchen()
                }
                Spacer()
                CustomTabView(selected: $selected)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

var tabs:[SelectedType] = [.home, .kitchen]

struct CustomTabView : View {
    
    @Binding var selected: SelectedType
    
    var body : some View {
        HStack {
            ForEach(tabs, id: \.self) { selectedTab in
                VStack(spacing: 10) {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 5)
                        .overlay(
                            Capsule()
                                .fill(self.selected == selectedTab ? Color("Pink") : Color.clear)
                                .frame(width: 55, height: 5)
                         )
                    Button(action: {
                        self.selected = selectedTab
                    }) {
                        VStack {
                            Image(selectedTab.rawValue)
                                .renderingMode(.original)
                            Text(selectedTab.rawValue)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
