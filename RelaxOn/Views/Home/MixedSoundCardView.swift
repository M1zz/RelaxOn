//
//  MixedSoundCardView.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/25.
//

import SwiftUI


struct MixedSoundCardView: View {
    var data: MixedSound
    let selectedID: String?
    @State var show = false
    @Binding var hasEdited: Bool
    @State var showingActionSheet: Bool = false
    
    @State var audioVolumes: (baseVolume: Float, melodyVolume: Float, naturalVolume: Float)
    
    var body : some View {
        ZStack {
            NavigationLink(destination: MusicView(data: data, audioVolumes: $audioVolumes),
                           isActive: $show) {
                Text("")
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Image(data.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                
                Text(data.name)
                    .fontWeight(.semibold)
                    .font(Font.system(size: 17))
                    .foregroundColor(Color.white)
            }
            .onTapGesture {
                show.toggle()
            }
            
            if hasEdited {
                Button(action: {
                    showingActionSheet = true
                }){
                    Image(systemName: "trash.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width / 2.4,
                       height: UIScreen.main.bounds.width / 2.4)
                .background(.gray.opacity(0.7))
                .cornerRadius(24)
                .offset(y: -14)
            }
        }
        .confirmationDialog(Text("Are you sure?"),
                            isPresented: $showingActionSheet,
                            titleVisibility: .visible) {
            Button("Delete items", role: .destructive) {
                hasEdited.toggle()
                userRepositories.remove(at: data.id)
                let data = getEncodedData(data: userRepositories)
                UserDefaultsManager.shared.standard.set(data, forKey: UserDefaultsManager.shared.recipes)
            }
            Button("Cancel", role: .cancel) {
                hasEdited.toggle()
            }
        } message: {
            Text("This item will be deleted. This action cannot be undone.")
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
}

struct MixedSoundCardView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyMixedSound = dummyMixedSound
        //        MixedSoundCard(data: dummyMixedSound,
        //                       selectedID: "", hasEdited: .constant(false))
        //        .background(ColorPalette.background.color)
    }
}
