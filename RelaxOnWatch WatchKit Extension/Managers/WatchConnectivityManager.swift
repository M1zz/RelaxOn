//
//  WatchConnectivityManager.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/09/11.
//

import UIKit

import WatchConnectivity

struct NotificationMessage: Identifiable {
    let id = UUID()
    let text: String
}

final class WatchConnectivityManager: NSObject, ObservableObject {
    
    // MARK: - singleton
    static let shared = WatchConnectivityManager()
    
    @Published var notificationMessage: NotificationMessage? = nil
    @Published var playMessageKey = "player"
    @Published var volumeMessageKey = "volume"
    @Published var listMessageKey = "list"
    @Published var titleMessageKey = "title"
    @Published var cdList: [String] = []
    @Published var cdTitle = ""
    
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
        
        print("메시지 전송됨, key: \(key), message: \(message)")
        WCSession.default.sendMessage([key : message], replyHandler: nil) { error in
            print("Cannot send play message: \(String(describing: error))")
        }
    }
}

extension WatchConnectivityManager: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let title = message[titleMessageKey] as? String {
            DispatchQueue.main.async { [weak self] in
                self?.cdTitle = title
                CDPlayerManager.shared.currentCDName = title
            }
        }
        
        if let state = message[playMessageKey] as? String {
            DispatchQueue.main.async { [weak self] in
                CDPlayerManager.shared.isPlaying = state == "play" ? true : false
            }
        }
        
        if let list = message[listMessageKey] as? [String] {
            DispatchQueue.main.async { [weak self] in
                self?.cdList = list
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}


