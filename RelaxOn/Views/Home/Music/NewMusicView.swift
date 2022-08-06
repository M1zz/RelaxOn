//
//  NewMusicView.swift
//  RelaxOn
//
//  Created by 최동권 on 2022/08/06.
//

import SwiftUI

struct NewMusicView: View {
    @State private var isActive = false
    
    @StateObject var viewModel = MusicViewModel()
    @State var animatedValue : CGFloat = 55
    @State var maxWidth = UIScreen.main.bounds.width / 2.2
    @State var showVolumeControl: Bool = false
    
    var data: MixedSound
    
    @Binding var audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float)
    
    var body: some View {
        ZStack {
            CDCoverView()
                .frame(width: .infinity, height: .infinity)
                .ignoresSafeArea()
                .blur(radius: 5)
            
            VStack(spacing: 0) {
                CDCoverView()
                    .frame(width: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal, 20)
                
                Text("LongSun")
                    .font(.system(.title, design: .default))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                MusicContollerView()
                    .padding(.top, 54)
            }
            
            VolumeControlView(showVolumeControl: $showVolumeControl,
                              audioVolumes: $audioVolumes,
                              data: data)
            .cornerRadius(20)
            .offset(y: UIScreen.main.bounds.height * 0.83)
        }
        .onAppear {
            viewModel.fetchData(data: data)
        }
        .onDisappear {
            viewModel.stop()
        }
        .background(
            NavigationLink(destination: MusicRenameView(), isActive: $isActive) {
                Text("")
            }
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    print("하이")
                } label: {
                    Image(systemName: "shevron.down")
                        .tint(.systemGrey1)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
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
                        print("하이")
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
                        .rotationEffect(.degrees(90))
                        .tint(.systemGrey1)
                }
            }
        }
    }
}

// MARK: ViewBuilder
extension NewMusicView {
    @ViewBuilder
    func MusicContollerView() -> some View {
        HStack (spacing: 56) {
            Button {
                print("ㅗㅑ")
            } label: {
                Image(systemName: "backward.fill")
                    .resizable()
                    .frame(width: 49, height: 35)
                    .tint(.white)
            }
            
            Button {
                
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: 44, height: 55)
                    .tint(.white)
            }
            
            Button {
                print("ㅗㅑ")
            } label: {
                Image(systemName: "forward.fill")
                    .resizable()
                    .frame(width: 49, height: 35)
                    .tint(.white)
            }
        }
    }
    
    // TODO: CDCover만들 곳
    @ViewBuilder
    func CDCoverView() -> some View {
        ZStack {
            Image(data.baseSound?.imageName ?? "")
                .resizable()
                .opacity(0.5)
                .frame(width: .infinity, height: .infinity)
            Image(data.melodySound?.imageName ?? "")
                .resizable()
                .opacity(0.5)
                .frame(width: .infinity, height: .infinity)
            Image(data.naturalSound?.imageName ?? "")
                .resizable()
                .opacity(0.5)
                .frame(width: .infinity, height: .infinity)
        }
    }
}
//
//struct NewMusicView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewMusicView()
//    }
//}
