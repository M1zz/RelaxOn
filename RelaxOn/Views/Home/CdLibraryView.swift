//
//  CdLibraryView.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI
import MediaPlayer

struct CdLibraryView: View {
    @StateObject var viewModel = MusicViewModel()
    @State private var isPresented = false
    @State var userRepositoriesState: [MixedSound] = []
    @State var showOnboarding: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                TimerNavigationLinkView()
                    .padding(.top, 56)
                CDListView(userRepositoriesState: $userRepositoriesState)
                Spacer()
                
                CDLibraryMusicController()
                    .onTapGesture {
                        if viewModel.mixedSound != nil {
                            self.isPresented.toggle()
                        }
                    }
                    .fullScreenCover(isPresented: $isPresented) {
                        if let selectedMixedSound = viewModel.mixedSound {
                            MusicView(data: selectedMixedSound, userRepositoriesState: $userRepositoriesState)
                        }
                    }
            }
            .background(Color.relaxBlack)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(.stack)
        .environmentObject(viewModel)
        .onAppear {
            let session = AVAudioSession.sharedInstance()
               do{
                   try session.setActive(true)
                   try session.setCategory(.playback, mode: .default,  options: .defaultToSpeaker)
               } catch{
                   print(error.localizedDescription)
               }
            
            let notFirstVisit = UserDefaultsManager.shared.notFirstVisit
            showOnboarding = !notFirstVisit
            
            if let data = UserDefaultsManager.shared.recipes {
                do {
                    let decoder = JSONDecoder()
                    userRepositories = try decoder.decode([MixedSound].self, from: data)
                    print("help : \(userRepositories)")
                    userRepositoriesState = userRepositories
                    
                    // TODO: - 추후 다른 방식으로 수정
                    viewModel.updateCDList(cdList: userRepositoriesState.map{mixedSound in mixedSound.name})
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
        .onChange(of: showOnboarding) { _ in
            if !showOnboarding {
                userRepositoriesState = userRepositories
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
//            StudioView(rootIsActive: $showOnboarding)
            OnboardingView(showOnboarding: $showOnboarding)
        }
    }
}

struct CdLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        MultiPreview {
            CdLibraryView()
        }
    }
}
