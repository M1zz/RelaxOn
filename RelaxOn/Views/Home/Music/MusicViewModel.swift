//
//  MusicViewModel.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI
import AVFoundation

final class MusicViewModel: NSObject, ObservableObject {
    @Published var baseAudioManager = AudioManager()
    @Published var melodyAudioManager = AudioManager()
    @Published var naturalAudioManager = AudioManager()
    @Published var isPlaying: Bool = false
    
    @Published var mixedSound: MixedSound?
    
    @Published var baseSoundUrls = [String: URL]()
    @Published var melodySoundUrls = [String: URL]()
    @Published var naturalSoundUrls = [String: URL]()
    
    override init() {
        super.init()
        
        DispatchQueue.global().async {
            self.getDownloadURL()
        }
    }
    
    func getDownloadURL() {
        let ref = FirebaseManager.shared.storage.reference()
        
        ref.child("Base").listAll { (result, error) in
            if let error = error {
                print(error)
            }
            for item in result!.items {
                //List storage reference
                let storageLocation = String(describing: item)
                let gsReference = FirebaseManager.shared.storage.reference(forURL: storageLocation)
                
                // Fetch the download URL
                gsReference.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print(error)
                    } else {
                        // Get the download URL for each item storage location
                        let fileName = url!.path.components(separatedBy: "Base/")[1].components(separatedBy: ".mp3")[0]
                        self.baseSoundUrls[fileName] = url!
                        
                        print(url!)
                    }
                }
            }
        }
        
        ref.child("Melody").listAll { (result, error) in
            if let error = error {
                print(error)
            }
            for item in result!.items {
                //List storage reference
                let storageLocation = String(describing: item)
                let gsReference = FirebaseManager.shared.storage.reference(forURL: storageLocation)
                
                // Fetch the download URL
                gsReference.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print(error)
                    } else {
                        // Get the download URL for each item storage location
                        let fileName = url!.path.components(separatedBy: "Melody/")[1].components(separatedBy: ".mp3")[0]
                        self.melodySoundUrls[fileName] = url!
                        
                        print(url!)
                    }
                }
            }
        }
        
        ref.child("Natural").listAll { (result, error) in
            if let error = error {
                print(error)
            }
            for item in result!.items {
                //List storage reference
                let storageLocation = String(describing: item)
                let gsReference = FirebaseManager.shared.storage.reference(forURL: storageLocation)
                
                // Fetch the download URL
                gsReference.downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print(error)
                    } else {
                        // Get the download URL for each item storage location
                        let fileName = url!.path.components(separatedBy: "Natural/")[1].components(separatedBy: ".mp3")[0]
                        self.naturalSoundUrls[fileName] = url!
                        
                        print(url!)
                    }
                }
            }
        }
    }
    
    func updateVolume(audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float)) {
        self.mixedSound?.baseSound?.audioVolume = audioVolumes.baseVolume
        self.mixedSound?.melodySound?.audioVolume = audioVolumes.melodyVolume
        self.mixedSound?.naturalSound?.audioVolume = audioVolumes.naturalVolume
    }
    
    func fetchData(data: MixedSound) {
        mixedSound = data
    }
    
    func play() {
        if isPlaying {
            baseAudioManager.playPause()
            melodyAudioManager.playPause()
            naturalAudioManager.playPause()
        } else {
            // play 할 때 mixedSound 볼륨 적용 시도
            baseAudioManager.startPlayer(track: mixedSound?.baseSound?.name ?? "base_default", volume: mixedSound?.baseSound?.audioVolume ?? 0.8)
            melodyAudioManager.startPlayer(track: mixedSound?.melodySound?.name ?? "base_default", volume: mixedSound?.melodySound?.audioVolume ?? 0.8)
            naturalAudioManager.startPlayer(track: mixedSound?.naturalSound?.name ?? "base_default", volume: mixedSound?.naturalSound?.audioVolume ?? 0.8)
        }
    }
    
    func stop() {
        if isPlaying {
            baseAudioManager.stop()
            melodyAudioManager.stop()
            naturalAudioManager.stop()
        }
    }
}
