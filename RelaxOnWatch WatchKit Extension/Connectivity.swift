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
    
    static let shared = Connectivity()

    override private init() {
        super.init()
        WCSession.default.delegate = self
        WCSession.default.activate()
    }
    
    public func sendFromWatch(watchInfo: [String]) {
        guard WCSession.default.activationState == .activated else {
            return
        }
        
        let watchInfo: [String: [String]] = [
            "watchInfo" : watchInfo
        ]
        WCSession.default.transferUserInfo(watchInfo)
    }
}

extension Connectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        let key = "cdInfo"
            guard let CDInfos = userInfo[key] as? [String] else {
            return
        }
        self.cdInfos = CDInfos
    }
}
