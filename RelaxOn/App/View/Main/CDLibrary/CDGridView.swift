//
//  CDGridView.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI

struct CDGridView: View {
    @StateObject var cdGridViewModel: CDGridViewModel = CDGridViewModel(CDList: CD.CDTempList)
    @State var selectedCD: CD?
    @State private var isPresent = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .top), count: 2), spacing: 18) {
                PlusCDImage
                
                ForEach(cdGridViewModel.CDList) { cd in
                    Button {
                        isPresent = true
                        selectedCD = cd
                    } label: {
                        NewCDCardView(CD: cd)
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isPresent, content: {
            CDPlayView(cd: $selectedCD)
        })
    }
}

extension CDGridView {
    
    var PlusCDImage: some View {
        VStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.relaxBlack)
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder()
                    VStack {
                        Image(systemName: "plus")
                            .font(Font.system(size: 54, weight: .ultraLight))
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                .foregroundColor(.systemGrey3)
            
            Text("Studio")
        }
    }
}

struct CDGridView_Previews: PreviewProvider {
    static var previews: some View {
        CDGridView()
    }
}
