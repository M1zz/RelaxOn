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

        ref.downloadURL { url, error in
            if let error = error {
                print(error.self)
            } else {
                self.saveSound(resource: resource, name: name, audioUrl: url!)
            }
        }
    }
    
    func saveSound(resource: String, name: String, audioUrl: URL) {
        // then lets create your document folder url
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("(resource)Sound")
        print(destinationUrl)

        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            print("The file already exists at path")

            // if the file doesn't exist
        } else {

            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) -> Void in
                guard let location = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: location, to: destinationUrl)
                    print("File moved to documents folder")
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }).resume()
        }
    }
}
