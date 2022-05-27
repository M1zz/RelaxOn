//
//  Music.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI
import AVKit

struct MusicView: View {
    
    @StateObject var viewModel = MusicViewModel()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2

    var data: MixedSound
    
    var body: some View {
        
        VStack {
            MusicInfo()
            Divider()
            ForEach(data.sounds) { singleSound in
                VStack {
                    SingleSong(song: singleSound)
                    Divider()
                }
            }
            
            MusicControlButton()
            
            Spacer()
            
            VolumeControlButton()
            
            Spacer()
        }
        .navigationBarTitle(Text(""),
                            displayMode: .inline)
        .onAppear {
            viewModel.fetchData(data: data)
        }
        .onDisappear {
            viewModel.stop()
        }
    }
    
    @ViewBuilder
    func MusicInfo() -> some View {
        HStack(alignment: .top) {
            if let thumbNailImage = UIImage(named: data.imageName) {
                Image(uiImage: thumbNailImage)
                    .resizable()
                    .frame(width: 180,
                           height: 180)
                    .cornerRadius(15)
            } else {
                // 문제시 기본이미지 영역
            }
            
            VStack(alignment: .leading) {
                Text(data.name)
                    .font(.title)
                    .bold()
                    .padding(.vertical)
                
                Text(data.description)
            }.padding()
            
            Spacer()
        }
        .padding(20)
    }
    
    @ViewBuilder
    func MusicTitle() -> some View {
        HStack {
            Text(data.name)
                .font(.title)
                .bold()
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func MusicControlButton() -> some View {
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
            
            Button(action: {
                viewModel.play()
                viewModel.isPlaying.toggle()
            }, label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(.black)
                    .frame(width: 55,
                           height: 55)
                    .background(Color.white)
                    .clipShape(Circle())
            })
        }
        .frame(width: maxWidth,
               height: maxWidth)
        .padding(.top,30)
    }
    
    @ViewBuilder
    func SingleSong(song: Sound) -> some View {
        HStack {
            Image(song.imageName)
                .resizable()
                .frame(width: 40,
                       height: 40)
            Text(song.name)
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func VolumeControlButton() -> some View {
        Button {
           
        } label: {
            Text("Volume Control")
                .bold()
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       maxHeight: 50)
                .background(.gray)
                .foregroundColor(.black)
                .cornerRadius(25)
        }
        .padding(.horizontal, 20)
    }
}

struct Music_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(data: MixedSound(id: 3,
                                   name: "test4",
                                   sounds: [Sound(id: 0, name: BaseAudioName.chineseGong.fileName, description: "chineseGong",imageName: "gong"),
                                            Sound(id: 2, name: MelodyAudioName.lynx.fileName, description: "lynx",imageName: "r1"),
                                            Sound(id: 6, name: NaturalAudioName.creekBabbling.fileName, description: "creekBabbling",imageName: "r3")
                                                                                      ],
                                   description: "test1",
                                   imageName: "r1"))
    }
}


