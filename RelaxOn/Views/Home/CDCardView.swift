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
    @Binding var isShwoingMusicView: Bool
    @Binding var userRepositoriesState: [MixedSound]
    @StateObject var viewModel: MusicViewModel
    
    // MARK: - General Properties
    var data: MixedSound
    
    // MARK: - Life Cycles
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                self.selectedMixedSound = data
                self.isShwoingMusicView.toggle()
            }, label: {
                ZStack {
                    CDCoverImageView(selectedImageNames: data.getImageName())
                        .frame(width: UIScreen.main.bounds.width * 0.43,
                               height: UIScreen.main.bounds.width * 0.43)
                }
                .fullScreenCover(item: $selectedMixedSound) { _ in
                    MusicView(viewModel: viewModel, data: data, userRepositoriesState: $userRepositoriesState)
                }
                .fullScreenCover(isPresented: $isPresent) {
                    MusicView(viewModel: viewModel, data: data, userRepositoriesState: $userRepositoriesState)
                }
            })
            Text(data.name)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.systemGrey1)
        }
        .onChange(of: viewModel.initiatedByWatch) { changedValue in
            if viewModel.currentTitle == data.name && viewModel.initiatedByWatch {
                isPresent = true
                viewModel.isMusicViewPresented = true
                viewModel.initiatedByWatch = false
            }
        }
        .onOpenURL { url in
            isPresent = (url == data.url)
        }
    }
}
//
//struct CDCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CDCardView(data: dummyMixedSound)
//    }
//}
