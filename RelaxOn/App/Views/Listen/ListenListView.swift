//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

/**
 커스텀 음원 목록이 노출되는 View
 하단 플레이어 바를 통해 음원 재생, 정지 기능
 */
struct ListenListView: View {
    
    @ObservedObject private var viewModel = MixedSoundsViewModel()
    @State private var searchText = ""
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            
            VStack {
                SearchBar(text: $searchText)
                    .frame(width: 350, height: 80)
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
                .listStyle(PlainListStyle())
                .navigationTitle("Listen")
                .navigationBarTitleDisplayMode(.large)
                .frame(width: 360)
                .onAppear {
                    viewModel.loadMixedSound()
                }
                SoundPlayerBottomView()
            }
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
