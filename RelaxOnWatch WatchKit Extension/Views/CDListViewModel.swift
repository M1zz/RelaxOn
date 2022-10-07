//
//  CDListViewModel.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/27.
//

import SwiftUI

final class CDListViewModel: ObservableObject {
    let cdManager = CDPlayerManager.shared
    let wcManager = WatchConnectivityManager.shared
    
    @Published var CDList: [String] = WatchConnectivityManager.shared.cdList
    
    func selectCD(of currentCDIndex: Int) {
        cdManager.currentCDName = wcManager.cdList[currentCDIndex]
        wcManager.sendMessage(key: "title", cdManager.currentCDName)
        cdManager.isPlaying = true
    }
    
    func getCDColor(_ currentCdIndex: Int) -> Color {
        return wcManager.cdList[currentCdIndex] == cdManager.currentCDName ? Color.relaxDimPurple : .white
    }
    
    func getCDList() {
        wcManager.sendMessage(key: "list", "request")
    }
}
