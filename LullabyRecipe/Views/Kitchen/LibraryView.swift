//
//  LibraryView.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/26.
//

import SwiftUI

struct LibraryView: View {
    
    var body: some View {
        
        VStack {
            libraryHeader
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10), count: 2), spacing: 20) {
                    
                    ForEach(0..<10){ idx in
                        if idx == 0 {
                            plusCDImage
                        } else {
                            cdImageView
                        }
                    }
                }
            }
        }
        .padding()
        
    }
    
    var libraryHeader: some View {
        HStack {
            Text("CD Library".uppercased())
                .font(.system(size: 24))
                
            Spacer()
            
            Button(action: {
                
            }) {
                Text("Edit")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 17))
            }
        }
    }
    
    var plusCDImage: some View {
        VStack(alignment: .leading) {
            VStack {
                Image(systemName: "plus")
                    .font(Font.system(size: 70, weight: .ultraLight))
            }
            .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
            .background(.gray)
            
            Text("Studio")
        }
    }
    
    var cdImageView: some View {
        VStack(alignment: .leading) {
            Image("Ambient")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
            Text("Name")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
