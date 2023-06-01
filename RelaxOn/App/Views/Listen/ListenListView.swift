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
    
    @State private var selectedFile = CustomSound()
    @State private var isShowingSheet = false
    
    // MARK: - Body
    var body: some View {
        
        VStack(alignment: .leading) {
            ZStack {
                Text(TabItems.listen.rawValue)
                    .foregroundColor(Color(.TitleText))
                    .font(.system(size: 24, weight: .bold))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 4)
            
            SearchBar(text: $viewModel.searchText)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            
            List {
                ForEach(viewModel.filteredSounds) { file in
                    ListenListCell(customSound: file)
                        .onTapGesture {
                            viewModel.selectedSound = file
                            isShowingSheet = true
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewModel.remove(at: index)
                    }
                }
                .listRowBackground(Color(.DefaultBackground))
                .listRowSeparator(.hidden)
            }
            .sheet(isPresented: $isShowingSheet, onDismiss: {
                isShowingSheet = false
            }) {
                SoundPlayerFullModalView()
            }
            
            Button {
                isShowingSheet = true
            } label: {
                SoundPlayerBottomView()
            }
            .sheet(isPresented: $isShowingSheet, onDismiss: {
                isShowingSheet = false
            }) {
                SoundPlayerFullModalView()
            }

        }
        .listStyle(PlainListStyle())
        .background(Color(.DefaultBackground))
        
        .onAppear {
            selectedFile = viewModel.lastSound
            viewModel.loadSound()
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
