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

    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.SearchBarText))
                .padding(.horizontal, 6)
            
            TextField("저장한 나만의 소리를 검색해보세요", text: $text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(.SearchBarText))
                .layoutPriority(1)
            
            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(.SearchBarText))
                }
            }
        }
        .frame(minHeight: 40)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color(.SearchBarBackground))
        .cornerRadius(8)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("저장한 나만의 소리를 검색해보세요"))
    }
}
