//
//  ListView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/30.
//

import SwiftUI

struct ListView: View {
    @Binding var tabNumber: Int
    @State var selected = -1
    
    var dummyTitles = ["Forest", "Midnight", "Reflection", "Foucs", "Favorite", "Calm", "Quiet"]
//    @ObservedObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 0) {
                    ForEach(Connectivity.shared.cdList.indices, id: \.self) { titleIdx in
                        if titleIdx == 0 {
                            Divider()
                        }
                        Button(action: {
//                            playerViewModel.currentCDName = Connectivity.shared.cdList[titleIdx]
                            
//                            playerViewModel.updateCurrentCDName(name: Connectivity.shared.cdList[titleIdx])
                            PlayerViewModel.shared.updateCurrentCDName(name: Connectivity.shared.cdList[titleIdx])
                            print("name: \(Connectivity.shared.cdList[titleIdx])")
                            print("name when clicked: \(PlayerViewModel.shared.currentCDName)")
                            selected = titleIdx
                            tabNumber = 1
                        }) {
                            Text(Connectivity.shared.cdList[titleIdx])
                                .foregroundColor(selected == titleIdx ? Color.relaxDimPurple : .white)
                                .font(.system(size: 18))
                                .padding(10)
                        }
                        .buttonStyle(.plain)
                        Divider()
                    }
                }
            }
        }
        .navigationTitle("Playlist")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView(tabNumber: .constant(0))
//    }
//}
