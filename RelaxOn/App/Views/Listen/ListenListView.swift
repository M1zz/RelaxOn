//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct ListenListView: View {
    
    @ObservedObject private var viewModel = MixedSoundsViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.mixedSounds, id: \.id) { mixedSound in
                    ListenListCell(title: mixedSound.name, ImageName: mixedSound.imageName)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.removeMixedSound(at: index)
                    }
                }
            }
            .navigationTitle("Listen")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadMixedSound()
            }
        }
    }
}

struct ListenListCell: View {
    // MARK: - Properties
    var title: String
    var ImageName: String
    
    var PlayButtonImageName: String = "play.fill"
    var PauseButtonImageName: String = "pause.fill"
    
    var body: some View {
        HStack {
            Image(ImageName)
                .frame(width: 60, height: 60)
                .background(.foreground.opacity(0.08)).cornerRadius(10)
                .offset(x: -10, y: 0)
            Text(title)
                .font(.body)
                .bold()
            Spacer()
            Button(action: {
                // TODO: Implement play/pause functionality
            }) {
                Image(systemName: PauseButtonImageName)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
            }
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
