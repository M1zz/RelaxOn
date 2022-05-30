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
    @State var showOnboarding: Bool = false
    @State var userName: String?
    
    var body: some View {
        NavigationView {
            VStack {
                switch selected {
                case .home:
                    Home(userName: $userName,
                         selected: $selected)
                case .kitchen:
                    Kitchen(selected: $selected)
                }
                Spacer()
                CustomTabView(selected: $selected)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal, viewHorizontalPadding)
            .background(ColorPalette.background.color,
                        ignoresSafeAreaEdges: .all)
        }
        .onAppear() {
            let notFirstVisit = UserDefaults.standard.bool(forKey: "notFirstVisit")
            showOnboarding = notFirstVisit ? false : true
        }
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnBoarding(showOnboarding: $showOnboarding)
                .onDisappear {
                    userName = UserDefaults.standard.string(forKey: "userName") ?? "Guest"
                }
        })
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
                                .fill(self.selected == selectedTab ? Color("Forground") : Color.clear)
                                .frame(width: 55, height: 5)
                        )
                    Button(action: {
                        self.selected = selectedTab
                    }) {
                        switch selectedTab {
                        case .home :
                            VStack {
                                Image(systemName: "house.fill")
                                    .tint(self.selected == selectedTab ? ColorPalette.forground.color : .white)
                                Text(selectedTab.rawValue)
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                        case .kitchen:
                            VStack {
                                Image(systemName: "sparkles")
                                    .tint(self.selected == selectedTab ? ColorPalette.forground.color : .white)
                                Text(selectedTab.rawValue)
                                    .foregroundColor(.white)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
            }
        }
        //        .background(ColorPalette.background).ignoresSafeArea()
        .padding(.horizontal)
    }
}
