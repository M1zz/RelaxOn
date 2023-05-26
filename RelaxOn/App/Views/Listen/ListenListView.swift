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
    
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @State private var searchText = ""
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                List {
                    ForEach(Array(viewModel.customSounds.keys).sorted(), id: \.self) { index in
                        if let fileName = viewModel.customSounds[index] {
                            ListenListCell(fileName: fileName)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.remove(at: index)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Listen")
                .navigationBarTitleDisplayMode(.large)
                .padding()
                .onAppear {
                    viewModel.loadSound()
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
