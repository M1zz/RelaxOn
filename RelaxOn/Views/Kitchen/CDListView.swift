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
    @State var isShwoingMusicView = false
    
    var body: some View {
        VStack {
            libraryHeader
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10), count: 2), spacing: 20) {
                    plusCDImage
                    ForEach(userRepositoriesState.reversed()){ mixedSound in
                        CDCardView(data: mixedSound, isShwoingMusicView: $isShwoingMusicView, userRepositoriesState: $userRepositoriesState)
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
        .onChange(of: isShwoingMusicView) { newValue in
            print("ss")
            if isShwoingMusicView == false {
                if let data = UserDefaultsManager.shared.standard.data(forKey: UserDefaultsManager.shared.recipes) {
                    do {
                        let decoder = JSONDecoder()
                        
                        userRepositories = try decoder.decode([MixedSound].self, from: data)
                        userRepositoriesState = userRepositories
                        print("help : \(userRepositories)")
                        
                        print("last", userRepositoriesState.last?.baseSound?.audioVolume)
                        
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                }
            }
        }
        
    }
    
    var libraryHeader: some View {
        HStack {
            Text("CD Library".uppercased())
                .font(.system(size: 24))
            
            Spacer()
            
            Button(action: {
                
            }) {
                Text("Edit")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 17))
            }
        }
    }
    
    var plusCDImage: some View {
        VStack(alignment: .leading) {
            NavigationLink(destination: StudioView()) {
                VStack {
                    Image(systemName: "plus")
                        .font(Font.system(size: 70, weight: .ultraLight))
                }
                .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
                .background(.gray)
            }
            .buttonStyle(.plain)
            
            Text("Studio")
        }
    }
}

struct CDListView_Previews: PreviewProvider {
    static var previews: some View {
        CDListView()
    }
}
