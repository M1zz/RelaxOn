//
//  CdLibraryView.swift
//  RelaxOn
//
//  Created by hyunho lee on 2022/05/22.
//

import SwiftUI
import MediaPlayer

struct CdLibraryView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                TimerNavigationLinkView()
                    .padding(.top, 56)
                CDListView()
                Spacer()
            }
            .background(Color.relaxBlack)
            .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .navigationViewStyle(.stack)
        .onAppear {
            let session = AVAudioSession.sharedInstance()
               do{
                   try session.setActive(true)
                   try session.setCategory(.playback, mode: .default,  options: .defaultToSpeaker)
               } catch{
                   print(error.localizedDescription)
               }
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
