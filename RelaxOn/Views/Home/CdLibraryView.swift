//
//  CdLibraryView.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI
import MediaPlayer


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
                TimerNavigationLinkView()
                    .padding(.top, 56)
                CDListView()
                Spacer()
            }
            .background(Color.relaxBlack)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(.stack)
        .onAppear() {
            let notFirstVisit = UserDefaultsManager.shared.standard.bool(forKey: UserDefaultsManager.shared.notFirstVisit)
            showOnboarding = notFirstVisit ? false : true
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            let session = AVAudioSession.sharedInstance()
               do{
                   try session.setActive(true)
                   try session.setCategory(.playback, mode: .default,  options: .defaultToSpeaker)
               } catch{
                   print(error.localizedDescription)
               }
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
        MultiPreview {
            CdLibraryView()
        }
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
