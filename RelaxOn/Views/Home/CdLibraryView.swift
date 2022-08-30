//
//  CdLibraryView.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI
import MediaPlayer

struct CdLibraryView: View {
    
    @State var showOnboarding: Bool = false
    @State var userRepositoriesData = userRepositories
    
    var body: some View {
        NavigationView {
            VStack {
                TimerNavigationLinkView()
                    .padding(.top, 56)
                CDListView(userRepositoriesState: userRepositoriesData)
                Spacer()
            }
            .background(Color.relaxBlack)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(.stack)
        .onAppear() {
            let notFirstVisit = UserDefaultsManager.shared.notFirstVisit
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
        .fullScreenCover(isPresented: $showOnboarding, onDismiss: {
            print("닫힘")
            userRepositoriesData = userRepositories
        } ,content: {
            OnboardingView(showOnboarding: $showOnboarding)
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
