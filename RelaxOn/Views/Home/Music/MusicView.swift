//
//  MusicView.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/08/06.
//

import SwiftUI

struct MusicView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isActive = false
    @State private var isFetchFirstData = true
    
    @StateObject var viewModel: MusicViewModel
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
            if offsetYOfControlView < UIScreen.main.bounds.height * 0.46 {
                offsetYOfControlView = UIScreen.main.bounds.height * 0.46
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
                if let selectedImageNames = viewModel.mixedSound?.getImageName() {
                    CDCoverImageView(selectedImageNames: selectedImageNames)
                        .toBlurBackground()
                }
                
                VStack {
                    CustomNavigationBar()
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 27, trailing: 20))
                    Spacer()
                }
                
                VStack {
                    VStack(spacing: 0) {
                        if let selectedImageNames = viewModel.mixedSound?.getImageName() {
                            CDCoverImageView(selectedImageNames: selectedImageNames)
                                .addDefaultBackground()
                                .padding(.horizontal, 20)
                                .frame(width: cdViewWidth, height: cdViewWidth - 40)
                                .aspectRatio(1, contentMode: .fit)
                        }
                        
                        Text(viewModel.mixedSound?.name ?? "")
                            .font(.system(size: cdNameFontSize, design: .default))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.top, 30)
                        
                        MusicControllerView()
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
                                    offsetYOfControlView = UIScreen.main.bounds.height * 0.46
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
                
                NavigationLink(isActive: $isActive) {
                    if let mixedSound = viewModel.mixedSound {
                        CDNamingView(goToPreviousView: $isActive,
                                     mixedSound: mixedSound,
                                     musicModelDelegate: self,
                                     previousView: .music)
                    }
                } label: {
                    Text("")
                }
                .hidden()
            }
            .onAppear {
                UIApplication.shared.beginReceivingRemoteControlEvents()
                
                if isFetchFirstData {
                    viewModel.fetchData(data: data)
                }
                self.isFetchFirstData = false
                timerManager.currentMusicViewModel = self.viewModel
                if let mixedSound = viewModel.mixedSound,
                   let baseImageName = viewModel.mixedSound?.baseSound?.fileName,
                   let melodyImageName = viewModel.mixedSound?.melodySound?.fileName,
                   let whiteNoiseImageName = viewModel.mixedSound?.whiteNoiseSound?.fileName {
                    WidgetManager.addMainSoundToWidget(baseImageName: baseImageName, melodyImageName: melodyImageName, whiteNoiseImageName: whiteNoiseImageName, name: mixedSound.name, id: mixedSound.id, isPlaying: viewModel.isPlaying, isRecentPlay: false)
                }
                viewModel.isMusicViewPresented = true
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
                viewModel.isMusicViewPresented = false
                UIApplication.shared.endReceivingRemoteControlEvents()
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: ViewBuilder
extension MusicView {
    @ViewBuilder
    func MusicControllerView() -> some View {
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

// MARK: - MusicVeiwDelegate
extension MusicView: MusicViewDelegate {
    func renameMusic(renamedMixedSound: MixedSound) {
        let firstIndex = userRepositoriesState.firstIndex { element in
            return element.id == viewModel.mixedSound?.id ?? -1
        }
        
        guard let index = firstIndex else {
            return
        }
        viewModel.mixedSound = renamedMixedSound
        userRepositories.remove(at: index)
        userRepositories.insert(renamedMixedSound, at: index)
        userRepositoriesState.remove(at: index)
        userRepositoriesState.insert(renamedMixedSound, at: index)
        
        let data = getEncodedData(data: userRepositories)
        UserDefaultsManager.shared.recipes = data
    }
}

//
//struct NewMusicView_Previews: PreviewProvider {
//    static var previews: some View {
//        MusicView()
//    }
//}
