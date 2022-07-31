//
//  FirebaseManager.swift
//  RelaxOn
//
//  Created by COBY_PRO on 2022/07/31.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject {
    
    let storage: Storage
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.storage = Storage.storage()
        
        super.init()
    }
    
}
