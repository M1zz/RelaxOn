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
    @State var isEditMode = false
    @State var selectedMixedSoundIds: [Int] = []
    
    var body: some View {
        
        VStack {
            libraryHeader
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10), count: 2), spacing: 20) {
                    plusCDImage
                    ForEach(userRepositoriesState.reversed()){ mixedSound in
                        CDCardView(data: mixedSound, audioVolumes: (baseVolume: mixedSound.baseSound?.audioVolume ?? 1.0, melodyVolume: mixedSound.melodySound?.audioVolume ?? 1.0, naturalVolume: mixedSound.naturalSound?.audioVolume ?? 1.0))
                            .disabled(isEditMode)
                            .overlay(alignment : .bottomTrailing) {
                                if isEditMode {
                                    if selectedMixedSoundIds.firstIndex(where: {$0 == mixedSound.id}) != nil {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                            .padding(.bottom, LayoutConstants.pading.bottomOfRadioButton)
                                            .padding(.trailing, LayoutConstants.pading.trailingOfRadioButton)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.white)
                                            .background(Image(systemName: "circle.fill").foregroundColor(.gray).opacity(0.5))
                                            .padding(.bottom, LayoutConstants.pading.bottomOfRadioButton)
                                            .padding(.trailing, LayoutConstants.pading.trailingOfRadioButton)
                                    }
                                }
                            }
                            .onTapGesture {
                                if isEditMode {
                                    if let index = selectedMixedSoundIds.firstIndex(where: {$0 == mixedSound.id}) {
                                        selectedMixedSoundIds.remove(at: index)
                                    } else {
                                        selectedMixedSoundIds.append(mixedSound.id)
                                    }
                                }
                            }
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
                .font(.system(size: 24))
                
            Spacer()
            
            Button(action: {
                if selectedMixedSoundIds.isEmpty {
                    isEditMode.toggle()
                } else {
                    print("hello")
                    print(selectedMixedSoundIds)
                }
            }) {
                if selectedMixedSoundIds.isEmpty {
                    Text(isEditMode ? "Done" : "Edit")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 17))
                } else {
                    Text("Delete")
                        .foregroundColor(.red)
                        .font(.system(size: 17))
                }
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

extension CDListView {
    private struct LayoutConstants {
        enum pading {
            static let trailingOfRadioButton: CGFloat = 10
            static let bottomOfRadioButton: CGFloat = 40
        }
    }
}

struct CDListView_Previews: PreviewProvider {
    struct dummy {
        static let MixedSound1 = MixedSound(id: 0,
                                         name: "test",
                                         baseSound: dummyBaseSound,
                                         melodySound: dummyMelodySound,
                                         naturalSound: dummyNaturalSound,
                                         imageName: "Recipe1")
        
        static let MixedSound2 = MixedSound(id: 1,
                                         name: "test2",
                                         baseSound: dummyBaseSound,
                                         melodySound: dummyMelodySound,
                                         naturalSound: dummyNaturalSound,
                                         imageName: "Recipe2")
        
        static let MixedSound3 = MixedSound(id: 2,
                                         name: "test3",
                                         baseSound: dummyBaseSound,
                                         melodySound: dummyMelodySound,
                                         naturalSound: dummyNaturalSound,
                                         imageName: "Recipe3")
        
        static let dummyBaseSound = Sound(id: 0,
                                   name: BaseAudioName.longSun.fileName,
                                   soundType: .base,
                                   audioVolume: 0.8,
                                   imageName: "LongSun")

        static let dummyMelodySound = Sound(id: 2,
                                     name: MelodyAudioName.ambient.fileName,
                                     soundType: .melody,
                                     audioVolume: 1.0,
                                     imageName: "Melody1")

        static let dummyNaturalSound = Sound(id: 6,
                                      name: NaturalAudioName.dryGrass.fileName,
                                      soundType: .natural,
                                      audioVolume: 0.4,
                                      imageName: "field")
    }
    static var previews: some View {
        CDListView(userRepositoriesState: [dummy.MixedSound1, dummy.MixedSound2, dummy.MixedSound3])
    }
}
