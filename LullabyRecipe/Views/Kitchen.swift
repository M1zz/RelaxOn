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

struct Kitchen : View {
 
    @State private var showingAlert = false
    var body : some View {
        
        VStack(spacing: 15) {
            Profile()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    SoundSelectView(sectionTitle: "Base Sound",
                                   soundType: "Base")
                    
                    SoundSelectView(sectionTitle: "Melody",
                                   soundType: "Melody")
                    
                    SoundSelectView(sectionTitle: "Natural Sound",
                                   soundType: "Natural")
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
        } label: {
            Text("Create")
                .frame(minWidth: 0, maxWidth: .infinity)
                .background(.green)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("제목을 넣자"),
                  message: Text("자장가가 완성되었습니다"),
                  dismissButton: .default(Text("닫기")))
        }
    }

    @ViewBuilder
    func SoundSelectView(sectionTitle: String,
                        soundType: String) -> some View {
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
                    
                    RadioButtonGroup(items: baseSounds,
                                     selectedId: soundType) { baseSelected in
                        print("baseSelected is: \(baseSelected)")
                    }
                    
//                    SoundCard(data: freshitems[0])
//                    SoundCard(data: freshitems[1])
//                    SoundCard(data: freshitems[2])
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



//enum SoundType {
//    case base
//    case melody
//    case natural
//}




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
