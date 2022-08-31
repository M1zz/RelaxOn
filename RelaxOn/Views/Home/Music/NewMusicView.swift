//
//  NewMusicView.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/08/06.
//

import SwiftUI

struct NewMusicView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isActive = false
    @State private var isFetchFirstData = true
    
    @StateObject var viewModel = MusicViewModel()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var showVolumeControl: Bool = false
    @State private var cdViewPadding = 81.0
    @State private var cdViewWidth = UIScreen.main.bounds.width
    @State private var cdViewHeight = UIScreen.main.bounds.height * 0.63
    @State private var cdNameFontSize = 28.0
    @State private var musicControlButtonWidth = 49.0
    @State private var musicPlayButtonWidth = 44.0
    
    var timerManager = TimerManager.shared
    
    @State var audioVolumes: (baseVolume: Float, melodyVolume: Float, whiteNoiseVolume: Float) = (0, 0, 0)
    @State private var offsetYOfControlView = UIScreen.main.bounds.height * 0.83 {
        didSet {
            if offsetYOfControlView < UIScreen.main.bounds.height * 0.5 {
                offsetYOfControlView = UIScreen.main.bounds.height * 0.5
            } else if offsetYOfControlView > UIScreen.main.bounds.height * 0.83 {
                offsetYOfControlView = UIScreen.main.bounds.height * 0.83
            }
        }
    }
    
    var data: MixedSound
    @Binding var userRepositoriesState: [MixedSound]
    
    var body: some View {
        NavigationView {
            ZStack {
                CDCoverView()
                    .frame(width: .infinity, height: .infinity)
                    .ignoresSafeArea()
                    .blur(radius: 5)
                
                VStack {
                    CustomNavigationBar()
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 27, trailing: 20))
                    Spacer()
                }
                
                VStack {
                    VStack(spacing: 0) {
                        CDCoverView()
                            .padding(.horizontal, 20)
                            .frame(width: cdViewWidth, height: cdViewWidth - 40)
                            .aspectRatio(1, contentMode: .fit)
                        
                        Text(viewModel.mixedSound?.name ?? "")
                            .font(.system(size: cdNameFontSize, design: .default))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        MusicContollerView()
                            .padding(.top, 54)
                    }
                    .frame(width: cdViewWidth, height: cdViewHeight)
                    .padding(.bottom, cdViewPadding)
                    
                    Spacer()
                }
                .padding(.top, UIScreen.main.bounds.height * 0.1)
                
                VolumeControlView(showVolumeControl: $showVolumeControl,
                                  audioVolumes: $audioVolumes,
                                  userRepositoriesState: $userRepositoriesState,
                                  viewModel: viewModel)
                .cornerRadius(20)
                .offset(y: offsetYOfControlView)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let draggedHeight = value.translation.height
                            let deviceHalfHeight = UIScreen.main.bounds.height * 0.5
                            let gradient = draggedHeight / deviceHalfHeight
                            offsetYOfControlView += draggedHeight / 5
                            
                            
                            if value.location.y > UIScreen.main.bounds.height * 0.82 {
                                return
                            } else if offsetYOfControlView == deviceHalfHeight {
                                return
                            } else {
                                if value.translation.height > 0 {
                                    cdViewWidth = UIScreen.main.bounds.width * 0.54 * gradient + UIScreen.main.bounds.width * 0.46
                                    cdViewHeight = UIScreen.main.bounds.height * 0.3 * gradient + UIScreen.main.bounds.height * 0.33
                                    cdNameFontSize = 6.0 * gradient + 22.0
                                    musicPlayButtonWidth = 18 * gradient + 26.0
                                    musicControlButtonWidth = 26 * gradient + 23
                                } else {
                                    cdViewWidth = UIScreen.main.bounds.width * 0.54 * (gradient) + UIScreen.main.bounds.width
                                    cdViewHeight = UIScreen.main.bounds.height * 0.3 * (gradient) + UIScreen.main.bounds.height * 0.63
                                    cdNameFontSize = 6.0 * (gradient) + 28.0
                                    musicPlayButtonWidth = 18.0 * (gradient) + 44
                                    musicControlButtonWidth = 26 * (gradient) + 49
                                }
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                let draggedHeight = value.predictedEndTranslation.height
                                if draggedHeight < -30 {
                                    offsetYOfControlView = UIScreen.main.bounds.height * 0.5
                                    cdViewWidth = UIScreen.main.bounds.width * 0.46
                                    cdViewHeight = UIScreen.main.bounds.height * 0.33
                                    cdNameFontSize = 22.0
                                    musicPlayButtonWidth = 26.0
                                    musicControlButtonWidth = 23
                                } else if draggedHeight > 30 {
                                    offsetYOfControlView = UIScreen.main.bounds.height * 0.83
                                    cdViewWidth = UIScreen.main.bounds.width
                                    cdViewHeight = UIScreen.main.bounds.height * 0.63
                                    cdNameFontSize = 28.0
                                    musicPlayButtonWidth = 44
                                    musicControlButtonWidth = 49
                                } else {
                                    offsetYOfControlView = UIScreen.main.bounds.height * 0.83
                                    cdViewWidth = UIScreen.main.bounds.width
                                    cdViewHeight = UIScreen.main.bounds.height * 0.63
                                    cdNameFontSize = 28.0
                                    musicPlayButtonWidth = 44
                                    musicControlButtonWidth = 49
                                }
                            }
                        }
                )
            }
            .onAppear {
                if isFetchFirstData {
                    viewModel.fetchData(data: data)
                }
                self.isFetchFirstData = false
                timerManager.currentMusicViewModel = self.viewModel
            }
            .onReceive(viewModel.$mixedSound, perform: { mixedSound in
                guard let changedMixedSound = mixedSound else { return }
                audioVolumes = (baseVolume: changedMixedSound.baseSound?.audioVolume ?? 0.12,
                                melodyVolume: changedMixedSound.melodySound?.audioVolume ?? 0.12,
                                whiteNoiseVolume: changedMixedSound.whiteNoiseSound?.audioVolume ?? 0.12)
            })
            .onDisappear {
                viewModel.stop()
                userRepositoriesState = userRepositories
            }
            .background(
                NavigationLink(destination: MusicRenameView(viewModel: viewModel, userRepositoriesState: $userRepositoriesState, mixedSound: viewModel.mixedSound ?? emptyMixedSound), isActive: $isActive) {
                    Text("")
                }
            )
            .navigationBarHidden(true)
        }
    }
    
    private func getEncodedData(data: [MixedSound]) -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            return encodedData
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        return nil
    }
}

// MARK: ViewBuilder
extension NewMusicView {
    @ViewBuilder
    func MusicContollerView() -> some View {
        HStack (spacing: 56) {
            Button {
                viewModel.setupPreviousTrack(mixedSound: viewModel.mixedSound ?? emptyMixedSound)
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .frame(width: musicControlButtonWidth, height: musicControlButtonWidth * 0.71)
                    .tint(.white)
            }
            
            Button {
                viewModel.playPause()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: musicPlayButtonWidth, height: musicPlayButtonWidth * 1.25) //1.25
                    .tint(.white)
            }
            
            Button {
                viewModel.setupNextTrack(mixedSound: viewModel.mixedSound ?? emptyMixedSound)
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .frame(width: musicControlButtonWidth, height: musicControlButtonWidth * 0.71)
                    .tint(.white)
            }
        }
    }
    
    // TODO: CDCover만들 곳
    @ViewBuilder
    func CDCoverView() -> some View {
        ZStack {
            if let baseSoundImageName = viewModel.mixedSound?.baseSound?.fileName {
                switch baseSoundImageName {
                case "music":
                    EmptyView()
                default:
                    Image(baseSoundImageName)
                        .resizable()
                        .frame(width: .infinity, height: .infinity)
                }
            }
            if let melodySoundImageName = viewModel.mixedSound?.melodySound?.fileName {
                switch melodySoundImageName {
                case "music":
                    EmptyView()
                default:
                    Image(melodySoundImageName)
                        .resizable()
                        .frame(width: .infinity, height: .infinity)
                }
            }
            if let whiteNoiseSoundImageName = viewModel.mixedSound?.whiteNoiseSound?.fileName {
                switch whiteNoiseSoundImageName {
                case "music":
                    EmptyView()
                default:
                    Image(whiteNoiseSoundImageName)
                        .resizable()
                        .frame(width: .infinity, height: .infinity)
                }
            }
//            Image(viewModel.mixedSound?.melodySound?.imageName ?? "")
//                .resizable()
//                .opacity(0.5)
//                .frame(width: .infinity, height: .infinity)
//            Image(viewModel.mixedSound?.whiteNoiseSound?.imageName ?? "")
//                .resizable()
//                .opacity(0.5)
//                .frame(width: .infinity, height: .infinity)
        }
    }
    
    @ViewBuilder
    func CustomNavigationBar() -> some View {
        HStack {
            Button {
                withAnimation {
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Image(systemName: "chevron.down")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 19, height: 20)
                    .tint(.systemGrey1)
            }
            
            Spacer()
            
            Menu {
                Button {
                    self.isActive.toggle()
                } label: {
                    HStack{
                        Text("Rename")
                        Image(systemName: "pencil")
                    }
                }
                
                Button(role: .destructive) {
                    let index = userRepositoriesState.firstIndex { mixedSound in
                        mixedSound.name == viewModel.mixedSound?.name ?? ""
                    }
                    userRepositories.remove(at: index ?? -1)
                    userRepositoriesState.remove(at: index ?? -1)
                    
                    let data = getEncodedData(data: userRepositories)
                    UserDefaultsManager.shared.recipes = data
                    userRepositoriesState = userRepositories
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    HStack{
                        Text("Delete")
                            .foregroundColor(.red)
                        Image(systemName: "trash")
                            .tint(.red)
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 19, height: 20)
                    .rotationEffect(.degrees(90))
                    .tint(.systemGrey1)
            }
        }
    }
}
//
//struct NewMusicView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMusicView()
//    }
//}
