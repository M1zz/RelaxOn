//
//  CDListView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/30.
//

import SwiftUI

struct CDListView: View {
    @Binding var tabSelection: Int
    @ObservedObject var viewModel = CDListViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.CDList.indices, id: \.self) { cdIndex in
                        
                        if cdIndex == 0 {
                            Divider()
                        }
                        
                        Button {
                            viewModel.selectCD(of: cdIndex)
                            tabSelection = 1
                        } label: {
                            Text(viewModel.CDList[cdIndex])
                                .foregroundColor(viewModel.getCDColor(cdIndex))
                                .font(.system(size: 18))
                                .padding(10)
                        }
                        .buttonStyle(.plain)
                        
                        Divider()
                    }
                }
            }
        }
        .onAppear {
            viewModel.getCDList()
        }
        .navigationTitle("Playlist")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CDListView_Previews: PreviewProvider {
    static var previews: some View {
        CDListView(tabSelection: .constant(0))
    }
}
