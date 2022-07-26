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
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10),
                                         count: 2),
                          spacing: 20) {
                    ForEach(0..<10, id: \.self){ idx in
                        if idx == 0 {
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
                        VStack(alignment: .leading) {
                            Image("Ambient")
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                            Text("Name")
                        }
                    }
                }
            }
        }
        .padding()
        
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
