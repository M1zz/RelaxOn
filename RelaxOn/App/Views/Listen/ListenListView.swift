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
        CustomSound(fileName: "나의 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .waterDrop),
        CustomSound(fileName: "빠른 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .waterDrop),
        CustomSound(fileName: "조용한 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .waterDrop),
    ]
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            
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
//                    ForEach(Array(viewModel.customSounds.keys).sorted(), id: \.self) { index in
//                        if let fileName = viewModel.customSounds[index] {
//                            ListenListCell(fileName: fileName)
//                        }
//                    }
                    ForEach(sample) { file in
                        ListenListCell(fileName: file.fileName)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.remove(at: index)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
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
