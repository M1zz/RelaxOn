//
//  LibraryView.swift
//  LullabyRecipe
//
//  Created by Minkyeong Ko on 2022/07/26.
//

import SwiftUI

struct CDListView: View {
    @State var isActive: Bool = false
    @State var userRepositoriesState: [MixedSound] = userRepositories
    @State var selectedImageNames = (
        base: "",
        melody: "",
        natural: ""
    )
    @State private var isEditMode = false
    @State private var selectedMixedSoundIds: [Int] = []
    @State private var showingActionSheet = false
    
    init(userRepositoriesState: [MixedSound] = userRepositories){
        Theme.navigationBarColors(background: UIColor(named: "RelaxBlack") ?? .black, titleColor: UIColor(named: "RelaxDimPurple") ?? .white)
        self.userRepositoriesState = userRepositoriesState
    }
    
    var body: some View {
        
        VStack {
            libraryHeader
            
            ScrollView(.vertical, showsIndicators: false) {

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), alignment: .top), count: 2), spacing: 18) {
                    plusCDImage.disabled(isEditMode)

                    ForEach(userRepositoriesState.reversed()){ mixedSound in

                        CDCardView(data: mixedSound, audioVolumes: (baseVolume: mixedSound.baseSound?.audioVolume ?? 1.0, melodyVolume: mixedSound.melodySound?.audioVolume ?? 1.0, whiteNoiseVolume: mixedSound.whiteNoiseSound?.audioVolume ?? 1.0))
                            .disabled(isEditMode)
                            .overlay(alignment : .bottomTrailing) {
                                if isEditMode {
                                    if selectedMixedSoundIds.firstIndex(where: {$0 == mixedSound.id}) != nil {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                            .padding(.bottom, LayoutConstants.Padding.bottomOfRadioButton)
                                            .padding(.trailing, LayoutConstants.Padding.trailingOfRadioButton)
                                    } else {
                                        Image(systemName: "circle")
                                            .foregroundColor(.white)
                                            .background(Image(systemName: "circle.fill").foregroundColor(.gray).opacity(0.5))
                                            .padding(.bottom, LayoutConstants.Padding.bottomOfRadioButton)
                                            .padding(.trailing, LayoutConstants.Padding.trailingOfRadioButton)
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
        .confirmationDialog("Are you sure?",
                            isPresented: $showingActionSheet) {
            Button("Delete \(selectedMixedSoundIds.count) CDs", role: .destructive) {
                selectedMixedSoundIds.forEach { id in
                    if let index = userRepositories.firstIndex(where: {$0.id == id}) {
                        userRepositories.remove(at: index)
                    }
                }
                let data = getEncodedData(data: userRepositories)
                UserDefaults.standard.set(data, forKey: "recipes")
                selectedMixedSoundIds = []
                isEditMode = false
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("These CDs will be deleted from your library")
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
    
    var libraryHeader: some View {
        HStack {
            Text("CD Library".uppercased())
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.systemGrey1)
                
            Spacer()
            
            Button(action: {
                if selectedMixedSoundIds.isEmpty {
                    isEditMode.toggle()
                } else {
                    showingActionSheet = true
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
            NavigationLink(destination: StudioView(rootIsActive: self.$isActive), isActive: self.$isActive) {
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
            .navigationBarTitleDisplayMode(.inline)
            
            Text("Studio")
        }
    }
}

extension CDListView {
    private struct LayoutConstants {
        enum Padding {
            static let trailingOfRadioButton: CGFloat = 10
            static let bottomOfRadioButton: CGFloat = 40
        }
    }
}

struct CDListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CDListView(userRepositoriesState: [dummyMixedSound, dummyMixedSound1, dummyMixedSound2, dummyMixedSound3])
                .navigationBarHidden(true)
        }
    }
}
