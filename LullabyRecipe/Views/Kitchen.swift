//
//  Kitchen.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI

var categories = ["Natural",
                  "Mind Peace",
                  "Focus",
                  "Deep Sleep",
                  "Lullaby"]

var mixedAudios: [Sound] = []

enum SoundType: String {
    case base
    case melody
    case natural
}

struct Kitchen : View {
 
    @State private var showingAlert = false
    @State private var selectedBaseSound: Sound = Sound(id: 0, name: "", description: "", imageName: "")
    @State private var selectedMelodySound: Sound = Sound(id: 0, name: "", description: "", imageName: "")
    @State private var selectedNaturalSound: Sound = Sound(id: 0, name: "", description: "", imageName: "")
    
    var body : some View {
        
        VStack(spacing: 15) {
            Profile()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    SoundSelectView(sectionTitle: "Base Sound",
                                    soundType: .base)
                    
                    SoundSelectView(sectionTitle: "Melody",
                                    soundType: .melody)
                    
                    SoundSelectView(sectionTitle: "Natural Sound",
                                    soundType: .natural)
                }
            }
            
            MixedAudioCreateButton()
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func Profile() -> some View {
        HStack(spacing: 12) {
            Image("logo")
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
            
            Text("Hi, Monica")
                .font(.body)
            
            Spacer()
            
            Button(action: {
                
            }) {
                Image("filter").renderingMode(.original)
            }
        }
    }
    
    @ViewBuilder
    func MixedAudioCreateButton() -> some View {
        Button {
            showingAlert = true
            mixedAudios = [selectedBaseSound, selectedMelodySound, selectedNaturalSound]
        } label: {
            Text("Create")
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.green)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("제목을 넣자"),
                  message: Text("선택된 음악은 \(selectedBaseSound.name), \(selectedMelodySound.name), \(selectedNaturalSound.name) 입니다"),
                  dismissButton: .default(Text("닫기")))
        }
    }

    @ViewBuilder
    func SoundSelectView(sectionTitle: String,
                        soundType: SoundType) -> some View {
        
        VStack(spacing: 15) {
            
            HStack {
                Text(sectionTitle)
                    .font(.title)
                
                Spacer()
                
//                Button(action: {
//
//                }) {
//                    Text("More")
//                }
//                .foregroundColor(Color("Color"))
                
            }.padding(.vertical, 15)
            
            ScrollView(.horizontal,
                       showsIndicators: false) {
                HStack(spacing: 15) {
                    
                    switch soundType {
                    case .base:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: baseSounds) { baseSelected in
                            print("baseSelected is: \(baseSelected)")
                            selectedBaseSound = baseSelected
                        }
                    case .natural:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: naturalSounds) { naturalSounds in
                            print("naturalSounds is: \(naturalSounds)")
                            selectedNaturalSound = naturalSounds
                        }
                    case .melody:
                        RadioButtonGroup(selectedId: soundType.rawValue,
                                         items: melodySounds) { melodySounds in
                            print("melodySounds is: \(melodySounds)")
                            selectedMelodySound = melodySounds
                        }
                    }
                }
            }
        }
    }
}

struct Kitchen_Previews: PreviewProvider {
    static var previews: some View {
        Kitchen()
    }
}

#warning("리팩토링으로 날려야함")
struct FreshCellView : View {
    
    var data : fresh
    @State var show = false
    
    var body : some View {
        
        ZStack {
            NavigationLink(destination: MusicView(data: baseSounds[0]),
                           isActive: $show) {
                Text("")
            }
            
            VStack(spacing: 10) {
                Image(data.image)
                    .resizable()
                    .cornerRadius(10)
                    .frame(width: 180,
                           height: 180,
                           alignment: .center)
                Text(data.name)
                    .fontWeight(.semibold)
                Text(data.price)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            .onTapGesture {
                show.toggle()
            }
        }
    }
}




//    @ViewBuilder
//    func SearchBar() -> some View {
//        HStack(spacing: 15) {
//            HStack {
//                Image(systemName: "magnifyingglass")
//                    .font(.body)
//
//                TextField("Search Groceries", text: $txt)
//            }
//            .padding(10)
//            .background(Color("Color1"))
//            .cornerRadius(20)
//
//            Button(action: {
//
//            }) {
//
//                Image("mic").renderingMode(.original)
//            }
//        }
//    }
