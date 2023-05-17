//
//  SoundListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundListView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    let fileNames: [String] = ["Garden", "Water Drop", "Gong", "Twitter", "Wind", "Wave1", "Wave2"]
    
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
            ForEach(fileNames, id: \.self) { fileName in
                NavigationLink(destination: SoundDetailView(originalSound: Sound(name: fileName))) {
                    gridViewItem(fileName)
                }
            }
        }
        .padding(20)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func gridViewItem(_ fileName: String) -> some View {
        
        VStack(alignment: .leading) {
            Text(fileName)
                .font(.title2)
                .bold()
            Image(systemName: "photo")
                .frame(width: 160, height: 160)
                .background {
                    Color.systemGrey1
                }
        }
        .foregroundColor(.black)
    }
}

struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
    }
}
