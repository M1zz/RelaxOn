//
//  CdLibraryView.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI
import MediaPlayer

struct CdLibraryView: View {
    
    @State var showOnboarding: Bool = false
    
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
        })
    }
}

struct CdLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        CdLibraryView()
    }
}
