//
//  SearchBarView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 검색창 View
 */
struct SearchBar: View {
    // TODO: 검색기능 구현
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("저장한 나만의 소리를 검색해보세요", text: $text)
                .foregroundColor(.primary)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("저장한 나만의 소리를 검색해보세요"))
    }
}
