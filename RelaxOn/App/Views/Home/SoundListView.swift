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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                gridView()
            }
        }
    }
    
    @ViewBuilder
    private func gridView() -> some View {
        
        LazyVGrid(columns: columns) {
            ForEach(originalSounds, id: \.self) { originalSound in
                NavigationLink(destination: SoundDetailView(originalSound: originalSound)) {
                    gridViewItem(originalSound)
                }
            }
        }
        .padding(20)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func gridViewItem(_ originalSound: OriginalSound) -> some View {
        
        VStack(alignment: .leading) {
            
            Text(originalSound.category.displayName)
                .font(.title2)
                .bold()
            
            Image(originalSound.category.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 140)
            
        }
        .foregroundColor(.black)
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
    }
}
