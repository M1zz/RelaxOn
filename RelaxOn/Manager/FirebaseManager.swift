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
    
    func getSound(resource: String, name: String) {
        let ref = FirebaseManager.shared.storage.reference().child("\(resource)/\(name).mp3")
        let localURL = URL(string: "\(resource)/")!
        
        ref.write(toFile: localURL) { url, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("에러에요 에러")
            } else {
                // Local file URL for "images/island.jpg" is returned
                print("Success to get Sound")
            }
        }
    }
}
