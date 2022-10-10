//
//  CDCardView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/07/28.
//

import SwiftUI

struct CDCardView: View {
    // MARK: - State Properties
    @State var selectedMixedSound: MixedSound?
    @State private var isPresent = false
    @EnvironmentObject private var viewModel: MusicViewModel
    
    // MARK: - General Properties
    var song: MixedSound
    
    // MARK: - Life Cycles
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.selectedMixedSound = song
            }, label: {
                ZStack {
                    CDCoverImageView(selectedImageNames: song.getImageName())
                        .frame(width: UIScreen.main.bounds.width * 0.43,
                               height: UIScreen.main.bounds.width * 0.43)
                }
                .fullScreenCover(item: $selectedMixedSound) { _ in
                    MusicView(song: song)
                }
                .fullScreenCover(isPresented: $isPresent) {
                    MusicView(song: song)
                }
            })
            Text(song.name)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.systemGrey1)
        }
        .onChange(of: viewModel.initiatedByWatch) { changedValue in
            if viewModel.currentTitle == song.name && viewModel.initiatedByWatch {
                isPresent = true
                viewModel.isMusicViewPresented = true
                viewModel.initiatedByWatch = false
            }
        }
        .onOpenURL { url in
            if url != song.url {
                selectedMixedSound = nil
            }
            isPresent = (url == song.url)
        }
    }
}
// 
//struct CDCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CDCardView(data: dummyMixedSound)
//    }
//}
