//
//  SoundListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

/**
 앱에 저장된 Original Sound 정보들이 그리드 뷰 형태의 리스트로 나열된 Main View
 */
struct SoundListView: View {

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.DefaultBackground)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ZStack {
                        Text(TabItems.home.rawValue)
                            .foregroundColor(Color(.TitleText))
                            .font(.system(size: 24, weight: .bold))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 4)
                    
                    SearchBar(text: $searchText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                    
                    ScrollView {
                        gridView()
                    }
                }

                .navigationDestination(
                    isPresented: $appState.showSoundDetail) {
                        SoundDetailView(isTutorial: false, originalSound: OriginalSound(name: "물방울", filter: .WaterDrop, category: .WaterDrop))
                    }
            }
        }

    }
    
    @ViewBuilder
    private func gridView() -> some View {
        
        LazyVGrid(columns: columns) {
            ForEach(filteredSounds(), id: \.self) { originalSound in
                NavigationLink(destination: SoundDetailView(isTutorial: false, originalSound: originalSound)) {
                    gridViewItem(originalSound)
                }
            }
            .padding(.bottom, 30)
        }
        .padding(24)
    }
    
    @ViewBuilder
    private func gridViewItem(_ originalSound: OriginalSound) -> some View {
        
        VStack(alignment: .leading) {
            
            Text(originalSound.category.displayName)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(.Text))
            
            Image(originalSound.category.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 140)
                .background(Color(hex: originalSound.color))
                .cornerRadius(8)
        }
    }
    
    private func filteredSounds() -> [OriginalSound] {
        if searchText.isEmpty {
            return SoundListView.originalSounds
        } else {
            return SoundListView.originalSounds.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
    }
}
