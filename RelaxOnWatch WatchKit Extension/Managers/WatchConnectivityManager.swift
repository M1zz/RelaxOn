//
//  WatchConnectivityManager.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/11.
//

import UIKit
import WatchConnectivity

final class WatchConnectivityManager: NSObject, ObservableObject {
    
    // MARK: - singleton
    static let shared = WatchConnectivityManager()
    
    @Published var playMessageKey = "player"
    @Published var volumeMessageKey = "volume"
    @Published var listMessageKey = "list"
    @Published var titleMessageKey = "title"
    
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            
            WCSession.default.activate()
        }
    }
            
    func sendMessage(key: String, _ message: String) {
        guard WCSession.default.activationState == .activated else {
          return
        }
        
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
        
        WCSession.default.sendMessage([ key: message ], replyHandler: nil) { error in
            print("Cannot send play message: \(String(describing: error))")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [ String: Any ]) {
        if let title = message[titleMessageKey] as? String {
            DispatchQueue.main.async {
                CDPlayer.shared.currentCDName = title
            }
        }
        
        if let state = message[playMessageKey] as? String {
            DispatchQueue.main.async {
                CDPlayer.shared.isPlaying = state == "play" ? true : false
            }
        }
        
        if let list = message[listMessageKey] as? [String] {
            DispatchQueue.main.async {
                CDPlayer.shared.CDList = list
            }
        }
        
        if let volume = message["volume"] as? Float {
            DispatchQueue.main.async {
                CDPlayer.shared.volume = volume
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
