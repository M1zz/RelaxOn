//
//  CDPlayerView.swift
//  RelaxOnWatch WatchKit Extension
//
//  Created by Minkyeong Ko on 2022/08/10.
//

import SwiftUI

struct CDPlayerView: View {
    @ObservedObject var viewModel = CDPlayerViewModel()
    @State var volume = 50.0
    
    var body: some View {
        ZStack {
            Image("MusicBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 10)
            
            VStack {
                Text(viewModel.currentCDName)
                
                HStack {
                    Button {
                        viewModel.playPrevious()
                    } label: {
                        Image(systemName: "backward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .disabled(viewModel.isPlayerEmpty())
                    .buttonStyle(.plain)
                    
                    Spacer()
                                    
                    Button {
                        viewModel.playPause()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(.black)
                                .frame(width: 50, height: 50)
                            Image(systemName: viewModel.getIconName())
                                .font(.system(size: 30))
                        }
                    }
                    .disabled(viewModel.isPlayerEmpty())
                    .buttonStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        viewModel.playNext()
                    } label: {
                        Image(systemName: "forward.end")
                            .font(.system(size: 20, weight: .medium))
                    }
                    .disabled(viewModel.isPlayerEmpty())
                    .buttonStyle(.plain)
                }
                .padding()
                
                Slider(value: Binding(
                    get: {
                        CDPlayerManager.shared.volume
                    },
                    set: {(newValue) in
                        CDPlayerManager.shared.changeVolume(volume: newValue)
                    }
                ))
                .tint(.white)
            }
        }
        .onAppear {
            viewModel.getSystemVolume()
        }
    }
}

struct CDPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CDPlayerView()
    }
}
