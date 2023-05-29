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
    
    // UI 확인용
    let sample = [
        CustomSound(fileName: "나의 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .WaterDrop),
        CustomSound(fileName: "빠른 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .WaterDrop),
        CustomSound(fileName: "조용한 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .WaterDrop),
    ]
    
    @State private var selectedFile: CustomSound? = nil
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
            
            SearchBar(text: $searchText)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            
            List {
                ForEach(sample) { file in
                    ListenListCell(fileName: file.title)
                        .onTapGesture {
                            selectedFile = file
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
            .sheet(item: $selectedFile) { file in
                SoundPlayerFullModalView(file: file)
            }
            
            Button {
                isShowingSheet = true
            } label: {
                SoundPlayerBottomView()
            }
            .sheet(isPresented: $isShowingSheet, onDismiss: {
                isShowingSheet = false
            }) {
                // FIXME: ViewModel now playing sound로 수정하기
                SoundPlayerFullModalView(file: sample.first!)
            }

        }
        .listStyle(PlainListStyle())
        .background(Color(.DefaultBackground))
        
        .onAppear {
            viewModel.loadSound()
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
