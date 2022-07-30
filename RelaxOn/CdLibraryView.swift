//
//  CdLibraryView.swift
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

struct CdLibraryView: View {
    
    @State var selected: SelectedType = .home
    @State var showOnboarding: Bool = false
    @State var userName: String?
    
    var body: some View {
        NavigationView {
            
            VStack {
                // MARK: TimerNavigationView를 위한 자리
                TimerNavigationLinkView()
                Divider()
                    .padding(.horizontal)
                CDListView()
                Spacer()
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear() {
            let notFirstVisit = UserDefaultsManager.shared.standard.bool(forKey: UserDefaultsManager.shared.notFirstVisit)
            showOnboarding = notFirstVisit ? false : true
        }
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardingView(showOnboarding: $showOnboarding)
                .onDisappear {
                    userName = UserDefaultsManager.shared.standard.string(forKey: UserDefaultsManager.shared.userName) ?? UserDefaultsManager.shared.guest
                }
        })
    }
}

struct CdLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        CdLibraryView()
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
