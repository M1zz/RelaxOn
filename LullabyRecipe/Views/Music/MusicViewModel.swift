//
//  MusicViewModel.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/25/22.
//

import SwiftUI
import AVFoundation

final class MusicViewModel: NSObject, ObservableObject {
    @Published var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
    @Published var album = album_Data()
    
    func getAudioData(from data: Sound) {
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: data.name,
                       ofType: "mp3")!))
        audioPlayer.isMeteringEnabled = true
        // 리팩토링 필요한 지점
        audioPlayer.numberOfLoops = -1
        
        
        let asset = AVAsset(url: audioPlayer.url!)
        
        asset.metadata.forEach { (meta) in
            
            switch(meta.commonKey?.rawValue) {
                
            case "artwork": album.artwork = meta.value == nil ? UIImage(named: "music")!.pngData()! : meta.value as! Data
                
            case "artist": album.artist = meta.value == nil ? "" : meta.value as! String
                
            case "type": album.type = meta.value == nil ? "" : meta.value as! String
                
            case "title": album.title = meta.value == nil ? "" : meta.value as! String
                
            default : ()
            }
        }
        
        if album.artwork.isEmpty {
            album.artwork = UIImage(named: "music")!.pngData()!
        }
    }
    
}
//    private var avPlayer: AVAudioPlayer!
//    private var arrayOfAllTracks = [Track]()
//
//    // call play track from view
//    func playTrack() {
//        play(track: arrayOfAllTracks[0])
//    }
//
//    private func play(track: Track) {
//        self.avPlayer = try! AVAudioPlayer(contentsOf: track.url,
//                                           fileTypeHint: AVFileType.mp3.rawValue)
//
//        self.avPlayer?.delegate = self
//
//        avPlayer.play()
//    }
//
//    private func playNext() {
//        let track = self.arrayOfAllTracks[1]
//        self.play(track: track)
//    }
//}
//
//extension MusicViewModel: AVAudioPlayerDelegate {
//    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
//        guard flag else { return }
//
//        self.playNext()
//    }
//}
//
//struct Track {
//    let url: URL!
//}
