//
//  CDListViewModel.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/27.
//

import SwiftUI

final class CDListViewModel: ObservableObject {
    var WCManager = WatchConnectivityManager.shared
    
    @Published var CDList: [String] = CDPlayer.shared.CDList
    
    func selectCD(of currentCDIndex: Int) {
        let currentCDName = CDList[currentCDIndex]
        
        CDPlayer.shared.currentCDName = currentCDName
        CDPlayer.shared.isPlaying = true
        
        WCManager.sendMessage(key: MessageKey.title, currentCDName)
    }
    
    func getCDColor(_ currentCdIndex: Int) -> Color {
        return CDList[currentCdIndex] == CDPlayer.shared.currentCDName ? Color.relaxDimPurple : .white
    }
    
    func getCDList() {
        WCManager.sendMessage(key: MessageKey.list, "request")
    }
}
