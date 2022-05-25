//
//  SoundCard.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/24/22.
//

import SwiftUI

//struct SoundCard: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct SoundCard_Previews: PreviewProvider {
//    static var previews: some View {
//        SoundCard()
//    }
//}


struct SoundCard : View {
    let soundFileName: String
    var data: Sound
    let callback: (String, Sound)->()
    let selectedID: String
    @State var show = false

//    init(
//        id: String,
//        data: Sound,
//        callback: @escaping (String)->(),
//        selectedID: String
//    ) {
//        self.id = id
//        self.data = data
//        self.callback = callback
//        self.selectedID = selectedID
//    }
    var body : some View {
        
        ZStack {
            VStack(spacing: 10) {
                Image(data.imageName)
                    .resizable()
                    .frame(width: 180,
                           height: 180,
                           alignment: .center)
                    .cornerRadius(10)
                    .border(selectedID == soundFileName ? .red : .clear, width: 3)

                Text(data.name)
                    .fontWeight(.semibold)
                Text(data.description)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            .onTapGesture {
                callback(soundFileName, data)
            }
        }
    }
}

struct SoundCard_Previews: PreviewProvider {
    static var previews: some View {
        SoundCard(soundFileName : "chinese_gong",
                       data: baseSounds[0],
                  callback: {_,_  in },
                       selectedID: "")
    }
}


struct RadioButtonGroup: View {
    @State var selectedId: String = ""
    let items : [Sound] // sound 를 받아야 함
    let callback: (Sound) -> ()
    
    var body: some View {
        HStack {
            ForEach(items) { item in
                SoundCard(soundFileName : item.name,
                          data: item,
                          callback: radioGroupCallback,
                          selectedID: selectedId)
            }
        }
    }
    
    func radioGroupCallback(id: String, audio: Sound) {
        selectedId = id
        callback(audio)
    }
}




//struct ColorInvert: ViewModifier {
//
//    @Environment(\.colorScheme) var colorScheme
//
//    func body(content: Content) -> some View {
//        Group {
//            if colorScheme == .dark {
//                content.colorInvert()
//            } else {
//                content
//            }
//        }
//    }
//}
//
//struct RadioButton: View {
//
//    @Environment(\.colorScheme) var colorScheme
//
//    let id: String
//    let callback: (String)->()
//    let selectedID : String
//    let size: CGFloat
//    let color: Color
//    let textSize: CGFloat
//
//    init(
//        _ id: String,
//        callback: @escaping (String)->(),
//        selectedID: String,
//        size: CGFloat = 20,
//        color: Color = Color.primary,
//        textSize: CGFloat = 14
//        ) {
//        self.id = id
//        self.size = size
//        self.color = color
//        self.textSize = textSize
//        self.selectedID = selectedID
//        self.callback = callback
//    }
//
//    var body: some View {
//        Button(action:{
//            self.callback(self.id)
//        }) {
//            HStack(alignment: .center, spacing: 10) {
//                Image(systemName: self.selectedID == self.id ? "largecircle.fill.circle" : "circle")
//                    .renderingMode(.original)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: self.size, height: self.size)
//                    .modifier(ColorInvert())
//                Text(id)
//                    .font(Font.system(size: textSize))
//                Spacer()
//            }.foregroundColor(self.color)
//        }
//        .foregroundColor(self.color)
//    }
//}
//
//struct RadioButtonGroup: View {
//
//    let items : [String]
//
//    @State var selectedId: String = ""
//
//    let callback: (String) -> ()
//
//    var body: some View {
//        VStack {
//            ForEach(0..<items.count) { index in
//                RadioButton(self.items[index], callback: self.radioGroupCallback, selectedID: self.selectedId)
//            }
//        }
//    }
//
//    func radioGroupCallback(id: String) {
//        selectedId = id
//        callback(id)
//    }
//}
//
//struct ContentView: View {
//    var body: some View {
//        HStack {
//            Text("Example")
//                .font(Font.headline)
//                .padding()
//            RadioButtonGroup(items: ["Rome", "London", "Paris", "Berlin", "New York"], selectedId: "London") { selected in
//                print("Selected is: \(selected)")
//            }
//        }.padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//struct ContentViewDark_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//        .environment(\.colorScheme, .dark)
//        .darkModeFix()
//    }
//}
