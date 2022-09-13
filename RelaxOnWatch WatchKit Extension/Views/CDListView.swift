//
//  CDListView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/30.
//

import SwiftUI

struct CDListView: View {
    @ObservedObject var watchConnectivityManager: WatchConnectivityManager
    @Binding var tabSelection: Int
    @State var selectedCDIndex = -1
    
    var body: some View {
        
        VStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 0) {
                    
                    ForEach(watchConnectivityManager.cdList.indices, id: \.self) { cdIndex in
                        
                        if cdIndex == 0 {
                            Divider()
                        }
                        
                        Button(action: {
                            CDPlayerManager.shared.currentCDName = watchConnectivityManager.cdList[cdIndex]
                            WatchConnectivityManager.shared.sendMessage(key: "title", CDPlayerManager.shared.currentCDName)
                            CDPlayerManager.shared.isPlaying = true
                            selectedCDIndex = cdIndex
                            tabSelection = 1
                        }) {
                            Text(watchConnectivityManager.cdList[cdIndex])
                                .foregroundColor(WatchConnectivityManager.shared.cdList[cdIndex] == CDPlayerManager.shared.currentCDName ? Color.relaxDimPurple : .white)
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
            WatchConnectivityManager.shared.sendMessage(key: "list", "request")
        }
        .navigationTitle("Playlist")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CDListView_Previews: PreviewProvider {
    static var previews: some View {
        CDListView(watchConnectivityManager: WatchConnectivityManager.shared, tabSelection: .constant(0))
    }
}
