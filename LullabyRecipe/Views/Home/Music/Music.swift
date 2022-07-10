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
    @State var showVolumeControl: Bool = false
    
    var data: MixedSound
    
    // 코드 변경
    // VolumeControl과 연결?되는 @State 변수 추가
    @State var newData: MixedSound
    
    var body: some View {
        
        ZStack(alignment: .top) {
            
            ColorPalette.background.color.ignoresSafeArea()
            
            VStack {
                MusicInfo()
                
                Divider()
                
                VStack(spacing: 20) {
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 20)
                    SingleSong(song: data.baseSound!)
                    
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 20)
                    SingleSong(song: data.melodySound!)
                    
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 20)
                    SingleSong(song: data.naturalSound!)
                }
                
                
                Spacer()
                
                VolumeControlButton()
            }
            .onAppear {
                viewModel.fetchData(data: data)
            }
            .onDisappear {
                viewModel.stop()
            }
        }
        .sheet(isPresented: $showVolumeControl,
               content: {
            // 코드 수정
            // newData 전달
            VolumeControl(showVolumeControl: $showVolumeControl,
                          baseVolume: (newData.baseSound?.audioVolume)!,
                          melodyVolume: (newData.melodySound?.audioVolume)!,
                          naturalVolume: (newData.naturalSound?.audioVolume)!,
                          data: data, newData: $newData)
        })
        .navigationBarTitle(Text(""),
                            // Todo :- edit 버튼 동작 .toolbar(content: { Button("Edit") { }}) }}
                            displayMode: .inline)
        
    }
    
    @ViewBuilder
    func MusicInfo() -> some View {
        HStack(alignment: .top) {
            if let thumbNailImage = UIImage(named: data.imageName) {
                Image(uiImage: thumbNailImage)
                    .resizable()
                    .frame(width: 156,
                           height: 156)
                    .cornerRadius(15)
            } else {
                // 문제시 기본이미지 영역
            }
            
            VStack(alignment: .leading) {
                Text(data.name)
                    .WhiteTitleText()
                MusicControlButton()
                Spacer()
            }
            .padding(.horizontal,1)
            .padding(.leading,20)
            .frame(height: 156)
            
            Spacer()
        }
        .padding(20)
        .padding(.leading,5)
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
        Button(action: {
            viewModel.play()
            viewModel.isPlaying.toggle()
        }, label: {
            
            HStack {
                (Text("\(viewModel.isPlaying ? "Pause " : "Play ")").bold() + Text(Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           maxHeight: 35)
                    .background(ColorPalette.buttonBackground.color)
                    .foregroundColor(.white)
                    .cornerRadius(17)
                    .font(.system(size: 16))
            }
        })
        
        //        }
        //        .frame(width: maxWidth,
        //               height: maxWidth)
        //        .padding(.top,30)
    }
    
    @ViewBuilder
    func SingleSong(song: Sound) -> some View {
        HStack {
            Image(song.imageName)
                .resizable()
                .frame(width: 80,
                       height: 80)
                .cornerRadius(24)
            VStack {
                Text(song.name)
                    .foregroundColor(.white)
                    .font(Font.system(size: 17))
                    .bold()
                // TODO: - type
            }
            // TODO: - X button
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func VolumeControlButton() -> some View {
        Button {
            showVolumeControl = true
            viewModel.stop()
        } label: {
            Text("Volume Control")
                .bold()
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       maxHeight: 50)
                .background(ColorPalette.buttonBackground.color)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 37)
    }
}

struct Music_Previews: PreviewProvider {
    static var previews: some View {
        let dummyMixedSound = MixedSound(id: 3,
                                         name: "test4",
                                         baseSound: dummyBaseSound,
                                         melodySound: dummyMelodySound,
                                         naturalSound: dummyNaturalSound,
                                         imageName: "r1")
        // 코드 수정
        MusicView(data: dummyMixedSound, newData: dummyMixedSound)
    }
}


