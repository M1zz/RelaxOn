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
    
    var body: some View {
        NavigationView {
            VStack {
                
                switch selected {
                case .home:
                    Home(selected: $selected)
                case .kitchen:
                    Kitchen()
                }
                Spacer()
                CustomTabView(selected: $selected)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .background(ColorPalette.tabBackground.color)
        }
        .onAppear() {
            let notFirstVisit = UserDefaults.standard.bool(forKey: "notFirstVisit")
            if notFirstVisit {
                showOnboarding = false
            } else {
                showOnboarding = true
            }
        }
        .fullScreenCover(isPresented: $showOnboarding, content: {
            Onboarding(showOnboarding: $showOnboarding)
        })
                     
//            UserDefaults.standard.set(true, forKey: "firstVisit")
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



struct Onboarding: View {
    
    @State var userName: String = ""
    @Binding var showOnboarding: Bool
    
    var body: some View {
        VStack(alignment:.center) {
            WhiteTitleText(title: "Nice to meet you.")
            
            WhiteTitleText(title: "What's your name?")

            TextField("Username", text: $userName)
                .frame(width: 220,
                       height: 50,
                       alignment: .center)
                .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(UIColor.label), lineWidth: 2)
                    )
                
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            Button {
                UserDefaults.standard.set(true, forKey: "notFirstVisit")
                UserDefaults.standard.set(userName, forKey: "userName")
                showOnboarding = false
            } label: {
                Text("start")
                    .frame(width: 60, height: 30)
                    .background(Color(UIColor.label))
                    .foregroundColor(ColorPalette.forground.color)
                    .cornerRadius(8)
                    
            }

        }
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
                                .background(.yellow)
                            Text(selectedTab.rawValue)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
//        .background(ColorPalette.background).ignoresSafeArea()
        .padding(.horizontal)
    }
}
