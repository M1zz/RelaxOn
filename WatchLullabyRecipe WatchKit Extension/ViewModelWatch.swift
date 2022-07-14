//
//  ViewModelWatch.swift
//  WatchLullabyRecipe WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/07/11.
//

import Foundation
import WatchConnectivity

class ViewModelWatch: NSObject, WCSessionDelegate, ObservableObject {
    
    var session: WCSession
    
    @Published var messageList: [[String]] = [["", ""]]
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    // 메시지를 받으면 트리거되는 함수
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            print("메시지 받음")
            self.messageList = message["message"] as? [[String]] ?? [["unknown", "hey"]]
            print(self.messageList)
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("application context 받음")
        DispatchQueue.main.async {
            self.messageList = applicationContext["message"] as? [[String]] ?? [["unknown", "hey"]]
        }
    }
}
