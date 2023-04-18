//
//  ListenListView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/09.
//

import SwiftUI

struct ListenListView: View {
    
    @ObservedObject private var viewModel = MixedSoundsViewModel()
    @State private var searchText = ""
    
    // MARK: - Body
    var body: some View {
        
        NavigationView {
            
            VStack {
                SearchBar(text: $searchText)
                    .frame(width: 350, height: 80)
                List {
                    ForEach(viewModel.mixedSounds, id: \.id) { mixedSound in
                        ListenListCell(title: mixedSound.name, ImageName: mixedSound.imageName)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.removeMixedSound(at: index)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Listen")
                .navigationBarTitleDisplayMode(.large)
                .frame(width: 360)
                .onAppear {
                    viewModel.loadMixedSound()
                }
                PlayerBar()
            }
        }
    }
}

struct PlayerBar: View {
    
    var body: some View {
        
        HStack {
            Spacer(minLength: 80)
            //선택한 사운드의 사진을 표시한다
            Image(systemName: "play.fill")
                .frame(width: 60, height: 60)
                .background(.foreground.opacity(0.08)).cornerRadius(10)
                .padding()
            
            Spacer()
            //선택한 사운드의 제목을 표시한다
            Text("Title")
                .frame(width: 210,alignment: .leading)
                .font(.title)
            
            Spacer()
            
            // 재생 혹은 정지 버튼을 보여준다
            Button {
                
            } label: {
                Image(systemName: "play.fill")
                    .frame(width: 60, height: 60)
                    //.offset(x: -30)
                    .foregroundColor(Color.black)
            }
            Spacer(minLength: 80)
        }
        .background(Color.systemGrey1)
        .ignoresSafeArea()
    }
}

struct SearchBar: View {
    
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search", text: $text)
                .foregroundColor(.primary)

            if !text.isEmpty {
                Button(action: {
                    self.text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10.0)
    }
}

struct ListenListCell: View {
    // MARK: - Properties
    var title: String
    var ImageName: String
    
    var PlayButtonImageName: String = "play.fill"
    var PauseButtonImageName: String = "pause.fill"
    
    var body: some View {
        HStack {
            Image(ImageName)
                .frame(width: 60, height: 60)
                .background(.foreground.opacity(0.08)).cornerRadius(10)
                .offset(x: 0, y: 0)
            Text(title)
                .font(.body)
                .bold()
            Spacer()
            Button(action: {
                // TODO: Implement play/pause functionality
            }) {
                Image(systemName: PauseButtonImageName)
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
            }
        }
    }
}

struct ListenListView_Previews: PreviewProvider {
    static var previews: some View {
        ListenListView()
    }
}
