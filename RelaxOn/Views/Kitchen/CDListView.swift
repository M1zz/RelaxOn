//
//  LibraryView.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/26.
//

import SwiftUI

struct CDListView: View {
    @State var userRepositoriesState: [MixedSound] = userRepositories
    @State var selectedImageNames = (
        base: "",
        melody: "",
        natural: ""
    )
    
    var body: some View {
        
        VStack {
            libraryHeader
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .top), count: 2), spacing: 18) {
                    plusCDImage
                    ForEach(userRepositoriesState.reversed()){ mixedSound in
                        CDCardView(data: mixedSound, audioVolumes: (baseVolume: mixedSound.baseSound?.audioVolume ?? 1.0, melodyVolume: mixedSound.melodySound?.audioVolume ?? 1.0, naturalVolume: mixedSound.naturalSound?.audioVolume ?? 1.0))
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if let data = UserDefaultsManager.shared.standard.data(forKey: UserDefaultsManager.shared.recipes) {
                do {
                    let decoder = JSONDecoder()
                    userRepositories = try decoder.decode([MixedSound].self, from: data)
                    print("help : \(userRepositories)")
                    userRepositoriesState = userRepositories
                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
        .onChange(of: userRepositories) { newValue in
            if let data = UserDefaultsManager.shared.standard.data(forKey: UserDefaultsManager.shared.recipes) {
                do {
                    let decoder = JSONDecoder()

                    userRepositories = try decoder.decode([MixedSound].self, from: data)
                    userRepositoriesState = userRepositories
                    print("help : \(userRepositories)")

                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
        
    }
    
    var libraryHeader: some View {
        HStack {
            Text("CD Library".uppercased())
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.systemGrey1)
                
            Spacer()
            
            Button(action: {
                
            }) {
                Text("Edit")
                    .foregroundColor(.relaxDimPurple)
                    .font(.body)
            }
        }
    }
    
    var plusCDImage: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: StudioView()) {
                ZStack {
                    VStack {
                        Image(systemName: "plus")
                            .font(Font.system(size: 54, weight: .ultraLight))
                    }
                    
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder()
                }
                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                .foregroundColor(.systemGrey3)
            }
            .buttonStyle(.plain)
        }
    }
}

struct CDListView_Previews: PreviewProvider {
    static var previews: some View {
        CDListView()
    }
}
