//
//  MusicView.swift
//  RelaxOn
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
    
    @Binding var audioVolumes: (baseVolume: Float, melodyVolume: Float, whiteNoiseVolume: Float)
    
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
                    SingleSong(song: data.baseSound ?? emptySound)
                    
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 20)
                    SingleSong(song: data.melodySound ?? emptySound)
                    
                    Divider()
                        .background(.white)
                        .padding(.horizontal, 20)
                    SingleSong(song: data.whiteNoiseSound ?? emptySound)
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
//        .sheet(isPresented: $showVolumeControl,
//               content: {
//            VolumeControlView(showVolumeControl: $showVolumeControl,
//                              audioVolumes: $audioVolumes,
//                              data: data)
//            .onDisappear {
//                viewModel.updateVolume(audioVolumes: audioVolumes)
//            }
//        })
        .navigationBarTitle(Text(""),
                            // Todo :- edit 버튼 동작 .toolbar(content: { Button("Edit") { }}) }}
                            displayMode: .inline)
    }
    
    @ViewBuilder
    func MusicInfo() -> some View {
        HStack(alignment: .top) {
            ZStack {
                Image("BaseIllust")
                    .resizable()
                    .frame(width: 156,
                           height: 156)
                    .cornerRadius(15)
                Image("MelodyIllust")
                    .resizable()
                    .frame(width: 156,
                           height: 156)
                    .cornerRadius(15)
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
            viewModel.playPause()
        }, label: {
            
            HStack {
                (Text("\(viewModel.isPlaying && viewModel.mixedSound?.name == data.name ? "Pause " : "Play ")").bold() + Text(Image(systemName: viewModel.isPlaying && viewModel.mixedSound?.name == data.name ? "pause.fill" : "play.fill")))
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           maxHeight: 35)
                    .background(ColorPalette.buttonBackground.color)
                    .foregroundColor(.white)
                    .cornerRadius(17)
                    .font(.system(size: 16))
            }
        })
    }
    
    @ViewBuilder
    func SingleSong(song: Sound) -> some View {
        HStack {
            Image(song.fileName)
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

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyMixedSound = MixedSound(name: "test4",
                                         baseSound: dummyBaseSound,
                                         melodySound: dummyMelodySound,
                                         whiteNoiseSound: dummyWhiteNoiseSound,
                                         fileName: "r1")
        //        MusicView(data: dummyMixedSound)
    }
}


