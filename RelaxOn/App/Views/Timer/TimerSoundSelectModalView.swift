//
//  TimerSoundSelectModalView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/28.
//

import SwiftUI

struct TimerSoundSelectModalView: View {
    
    @EnvironmentObject var viewModel: CustomSoundViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        if let selectedSound = viewModel.selectedSound {
                            viewModel.setSelectedSound(selectedSound)
                        }
                        if viewModel.isPlaying {
                            viewModel.stopSound()
                            viewModel.play(with: viewModel.sound)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("완료")
                            .foregroundColor(Color(.PrimaryPurple))
                            .padding()
                    }
                }
                
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                
                List {
                    ForEach(viewModel.filteredSounds) { file in
                        TimerSoundListCell(file: file)
                    }
                    .listRowBackground(Color(.DefaultBackground))
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
        .onAppear {
            viewModel.loadSound()
        }
    }
}

struct TimerSoundSelectModalView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSoundSelectModalView()
            .environmentObject(CustomSoundViewModel())
    }
}
