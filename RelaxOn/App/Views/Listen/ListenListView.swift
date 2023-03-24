//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct ListenListView: View {
    
    @State private var items = ["My Water Drop", "Peaceful Water Sound"]
    
    // MARK: - Body
    var body: some View {
        // TODO: 1. 커스텀 셀 구현 - 이미지 + 제목 + 재생/정지 버튼
        // TODO: 2. 밀어서 Remove
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    ListenListCell(title: item, ImageName: "photo")
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Listen")
            .navigationBarTitleDisplayMode(.large)
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
            Image(systemName: ImageName)
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
