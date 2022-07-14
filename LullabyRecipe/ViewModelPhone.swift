//
//  ViewModelPhone.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/11.
//

import Foundation
import WatchConnectivity

class ViewModelPhone: NSObject, WCSessionDelegate, ObservableObject {
    
    @Published var messageFromWatch = ""
    
    var session: WCSession
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.messageFromWatch = message["message"] as? String ?? "Unknown"
        }
    }
    
    // WCSessionDelegate를 만족하기 위한 함수 1
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // WCSessionDelegate를 만족하기 위한 함수 2
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    // WCSessionDelegate를 만족하기 위한 함수 3
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}
