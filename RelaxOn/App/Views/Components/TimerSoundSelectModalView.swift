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
    
    // UI 확인용
    let sample = [
        CustomSound(fileName: "나의 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .WaterDrop),
        CustomSound(fileName: "빠른 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .WaterDrop),
        CustomSound(fileName: "조용한 물방울 소리", category: .waterDrop, audioVariation: .init(), audioFilter: .WaterDrop),
    ]
    
    var filteredSounds: [CustomSound] {
        if viewModel.searchText.isEmpty {
            return sample
        } else {
            return sample.filter { $0.title.contains(viewModel.searchText) }
        }
    }
    
    var body: some View {
        
        ZStack {
            Color(.DefaultBackground)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        if let selectedSound = viewModel.selectedSound {
                            viewModel.setTimerMainViewSelectedSound(selectedSound)
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
                    ForEach(filteredSounds) { file in
                        TimerSoundListCell(file: file)
                    }
                    .listRowBackground(Color(.DefaultBackground))
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

struct TimerSoundSelectModalView_Previews: PreviewProvider {
    static var previews: some View {
        TimerSoundSelectModalView()
    }
}
