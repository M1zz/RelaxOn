//
//  Music.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI
import AVKit


let url = Bundle.main.path(forResource: "ocean_4", ofType: "mp3")
let url2 = Bundle.main.path(forResource: "ocean_4", ofType: "mp3")

struct MusicView: View {
    @StateObject var viewModel = MusicViewModel()
    var data: Sound
    
    @State var audioPlayer2 = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: url2!))
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var time : Float = 0
    
    var body: some View {
        
        VStack {
            MusicTitle()
            
            Spacer(minLength: 0)
            
            if !viewModel.album.artwork.isEmpty {
                Image(uiImage: UIImage(data: viewModel.album.artwork)!)
                    .resizable()
                    .frame(width: 250,
                           height: 250)
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
                    Image(systemName: viewModel.album.isPlaying ? "pause.fill" : "play.fill")
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
            
            MusicSlider()
            
            Spacer(minLength: 0)
        }
        .onReceive(timer) { (_) in
            if viewModel.audioPlayer.isPlaying {
                viewModel.audioPlayer.updateMeters()
                viewModel.album.isPlaying = true
                time = Float(viewModel.audioPlayer.currentTime / viewModel.audioPlayer.duration)
                startAnimation()
            } else {
                viewModel.album.isPlaying = false
            }
        }
        .onAppear {
            viewModel.getAudioData(from: data)
        }
    }
    
    @ViewBuilder
    func MusicTitle() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                
                Text(viewModel.album.title)
                    .fontWeight(.semibold)
                
                HStack(spacing: 10){
                    
                    Text(viewModel.album.artist)
                        .font(.caption)
                    
                    Text(viewModel.album.type)
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
    
    @ViewBuilder
    func MusicSlider() -> some View {
        Slider(value: Binding(get: {time}, set: { (newValue) in
            time = newValue
            
            viewModel.audioPlayer.currentTime = Double(time) * viewModel.audioPlayer.duration
            viewModel.audioPlayer.play()
        }))
        .padding()
    }
    
    private func play() {
        if viewModel.audioPlayer.isPlaying {
            viewModel.audioPlayer.pause()
        } else {
            viewModel.audioPlayer.play()
            
            audioPlayer2.play()
        }
    }
    
    func startAnimation() {
        var power : Float = 0
        
        for i in 0 ..< viewModel.audioPlayer.numberOfChannels {
            power += viewModel.audioPlayer.averagePower(forChannel: i)
        }
        let value = max(0, power + 55)
        let animated = CGFloat(value) * (maxWidth / 55)
        
        withAnimation(Animation.linear(duration: 0.01)) {
            self.animatedValue = animated + 55
        }
    }
}

class album_Data : ObservableObject {
    
    @Published var isPlaying = false
    @Published var title = ""
    @Published var artist = ""
    @Published var artwork = Data(count: 0)
    @Published var type = ""
}

struct Music_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(data: Sound(id: 0,
                              name: "chinese_gong",
                              description: "chinese gong sound",
                              imageName: "gong"))
    }
}


