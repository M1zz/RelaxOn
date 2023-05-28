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
    @State private var isEditing: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(.SearchBarText))
                .padding(.horizontal, 6)
            
            if isEditing {
                TextField("", text: $text)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.SearchBarText))
                    .layoutPriority(1)
                    .textFieldStyle(.plain)
                    .transition(.opacity)

            } else {
                Button(action: {
                    withAnimation {
                        isEditing.toggle()
                    }
                }) {
                    HStack {
                        Text("저장한 나만의 소리를 검색해보세요")
                            .font(.system(size: 14))
                            .foregroundColor(Color(.SearchBarText))
                            .frame(minHeight: 40)
                        
                        Spacer()
                    }
                }
                .transition(.opacity)
                .frame(maxWidth: .infinity)
            }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    withAnimation {
                        isEditing.toggle()
                    }
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
