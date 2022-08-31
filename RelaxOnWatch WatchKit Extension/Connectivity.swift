//
//  Connectivity.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import WatchConnectivity
import SwiftUI

enum PlayStates: String {
    case play
    case pause
    case backward
    case forward
}

final class Connectivity: NSObject, ObservableObject {
    @Published var cdInfos: [String] = []
    @Published var cdList: [String] = []
    
    static let shared = Connectivity()

    override init() {
        super.init()
        guard WCSession.isSupported() else {
            return
        }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    public func sendFromWatch(watchInfo: [String]) {
        print("sended from watch")
        guard WCSession.default.activationState == .activated else {
            return
        }
        
        let watchInfo: [String: [String]] = [
            "watchInfo" : watchInfo
        ]
        WCSession.default.sendMessage(watchInfo, replyHandler: nil, errorHandler: {(error) in
            print(error)
            print("send message failed from watch")
        })
    }
}

extension Connectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("received cdinfo")
        let key = "cdInfo"
            guard let CDInfos = userInfo[key] as? [String] else {
            return
        }
        self.cdInfos = CDInfos
        PlayerViewModel.shared.updateCurrentCDName(name: self.cdInfos[1])
        print(PlayerViewModel.shared.cdinfos)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("received application context")
        let key = "cdList"
        guard let CDList = applicationContext[key] as? [String] else {
            return
        }
        self.cdList = CDList
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("received message")
        let key = "cdInfo"
            guard let CDInfos = message[key] as? [String] else {
            return
        }
        self.cdInfos = CDInfos
        PlayerViewModel.shared.updateCurrentCDName(name: self.cdInfos[1])
        print(PlayerViewModel.shared.cdinfos)
    }
}
