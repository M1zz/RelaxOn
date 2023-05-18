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
    
    // TODO: Common 파일에서 퍼블릭하게 사용해야할 필요가 있는지 고민
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // TODO: 앱 번들에 저장되어있는 mp3 파일을 기준으로 Original Sounds가 존재하도록 하고 배열 삭제해야함
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
            // TODO: fileNames 배열 삭제 -> OriginalSounds로 각 그리드뷰의 타이틀 지정
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
            
            // TODO: OriginalSound의 fileName이나 Category로 title 설정
            Text(fileName)
                .font(.title2)
                .bold()
            
            // TODO: OriginalSound의 defaultImage로 설정
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
