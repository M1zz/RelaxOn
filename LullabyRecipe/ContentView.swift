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
var tabs:[SelectedType] = [.home, .kitchen]

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
            .edgesIgnoringSafeArea(.bottom)
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


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
