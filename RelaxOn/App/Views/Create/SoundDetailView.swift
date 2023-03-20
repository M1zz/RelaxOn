//
//  SoundDetailView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI
import AVFoundation

struct SoundDetailView: View {
    // MARK: - Properties
    var fileName: String // SoundListView에서 전달받은 파일 이름
    
    @State var volume: Float = 0.5
    @State var isShowingSheet: Bool = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            Text("Drag to find your sound")
                .foregroundColor(.black)
                .font(.title)
            
            ZStack {
                Image("CustomSoundSpace")
                    .zIndex(0)
                Text("💧")
                    .font(.system(size: 34))
                    .frame(width: 30, height: 30)
                    .offset(x: -15, y: 10)
                    .zIndex(1)
            }//ZStack
            .padding(24)
            
            // State 변수 값을 변경하고 전달하기 위한 임시 슬라이더 텍스트
            Text("Volume Slider")
                .font(.title3)
            // State 변수 값을 변경하고 전달하기 위한 임시 슬라이더
            Slider(value: $volume, in: 0.0 ... 1.0)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .foregroundColor(.yellow)
            
            HStack {
                Button(action: {
                    playAudio()
                }) {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.systemGrey3)
                }
                Button(action: {
                    stopAudio()
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.systemGrey3)
                }
            }//HStack
        }//VStack
        
        .navigationBarTitle(fileName, displayMode: .inline)
        .font(.system(size: 24, weight: .bold))
        
        .toolbar {
            Button {
                print("tapped done button")
                isShowingSheet.toggle()
            } label: {
                Text("Done")
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 20))
            }
            .sheet(isPresented: $isShowingSheet) {
                SoundSaveView(volume: $volume)
            }
        }
        
        // MARK: - Life Cycle
        .onAppear() {
            isPlaying = true
            audioPlayer?.play() // 노래가 끝났는지 안끝났는지 확인해서 재생시키기
        }
        .onDisappear() {
            audioPlayer?.stop()
            isPlaying = false
        }
        .onChange(of: volume) { value in
            audioPlayer?.volume = value
        }
    }
    
    // MARK: - functions
    func playAudio() {
        if let url = Bundle.main.url(forResource: "Garden", withExtension: ".mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                isPlaying = true
            } catch {
                print("오디오 재생 Error : \(error.localizedDescription)")
            }
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(fileName: "Water Drop")
    }
}
