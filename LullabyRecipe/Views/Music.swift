//
//  Music.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI
import AVKit

struct MusicView: View {
    let viewModel = MusicViewModel()
    
    var data: Sound
    @State var audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url!))
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @StateObject var album = album_Data()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var time : Float = 0
    
    var body: some View {
        
        VStack{
            MusicTitle()
            
            Spacer(minLength: 0)
            
            if album.artwork.count != 0 {
                
                Image(uiImage: UIImage(data: album.artwork)!)
                    .resizable()
                    .frame(width: 250, height: 250)
                    .cornerRadius(15)
            }
            
            ZStack {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.05))
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: animatedValue / 2,
                               height: animatedValue / 2)
                }
                .frame(width: animatedValue, height: animatedValue)
                
                Button(action: play) {
                    Image(systemName: album.isPlaying ? "pause.fill" : "play.fill")
                        .foregroundColor(.black)
                        .frame(width: 55,
                               height: 55)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }
            .frame(width: maxWidth,
                   height: maxWidth)
            .padding(.top,30)
            
            
            Slider(value: Binding(get: {time}, set: { (newValue) in
                
                time = newValue
                
                audioPlayer.currentTime = Double(time) * audioPlayer.duration
                audioPlayer.play()
            }))
            .padding()
            
            Spacer(minLength: 0)
        }
        .onReceive(timer) { (_) in
            
            if audioPlayer.isPlaying {
                audioPlayer.updateMeters()
                album.isPlaying = true
                time = Float(audioPlayer.currentTime / audioPlayer.duration)
                startAnimation()
            } else {
                album.isPlaying = false
            }
        }
        .onAppear(perform: getAudioData)
    }
    
    @ViewBuilder
    func MusicTitle() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                
                Text(album.title)
                    .fontWeight(.semibold)
                
                HStack(spacing: 10){
                    
                    Text(album.artist)
                        .font(.caption)
                    
                    Text(album.type)
                        .font(.caption)
                }
            }
            
            Spacer(minLength: 0)
            
            Button(action: {}) {
                
                Image(systemName: "suit.heart.fill")
                    .foregroundColor(.red)
                    .frame(width: 45, height: 45)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            
            Button(action: {}) {
                
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.black)
                    .frame(width: 45, height: 45)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .padding(.leading,10)
        }
        .padding()
    }
    
    private func play() {
        
        if audioPlayer.isPlaying{
            
            audioPlayer.pause()
        } else {
            
            audioPlayer.play()
        }
    }
    
    private func getAudioData() {
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
    
    func startAnimation() {
        var power : Float = 0
        
        for i in 0..<audioPlayer.numberOfChannels{
            power += audioPlayer.averagePower(forChannel: i)
        }
        let value = max(0, power + 55)
        let animated = CGFloat(value) * (maxWidth / 55)
        
        withAnimation(Animation.linear(duration: 0.01)) {
            self.animatedValue = animated + 55
        }
    }
}

let url = Bundle.main.path(forResource: "Ocean_4", ofType: "mp3")

class album_Data : ObservableObject{
    
    @Published var isPlaying = false
    @Published var title = ""
    @Published var artist = ""
    @Published var artwork = Data(count: 0)
    @Published var type = ""
}

struct Music_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(data: Sound(id: 0,
                              name: "Chinese_Gong",
                              description: "chinese gong sound",
                              imageName: "gong"))
    }
}


//import AVFoundation
//
//class MusicViewModel: NSObject, ObservableObject {
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
