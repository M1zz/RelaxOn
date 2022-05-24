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
    var data : Sound
    let callback: (String)->()
    let selectedID : String
    @State var show = false
    
    let id: String

    init(
        id: String,
        data data: Sound,
        callback: @escaping (String)->(),
        selectedID: String
    ) {
        self.id = id
        self.selectedID = selectedID
        self.callback = callback
        self.data = data
    }
    
    
    var body : some View {
        
        ZStack {
            VStack(spacing: 10) {
                Image(data.imageName)
                    .resizable()
                    .frame(width: 180,
                           height: 180,
                           alignment: .center)
                    .cornerRadius(10)
                    .border(selectedID == id ? .red : .clear, width: 3)

                Text(data.name)
                    .fontWeight(.semibold)
                Text(data.description)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }
            
            .onTapGesture {
                //self.show.toggle()
                self.callback(self.id)
            }
        }
    }
}

struct SoundCard_Previews: PreviewProvider {
    static var previews: some View {
        SoundCard(id : "asdf",
                       data: baseSounds[0],
                       callback: {_ in },
                       selectedID: "")
    }
}


struct RadioButtonGroup: View {
    
    let items : [Sound] // sound 를 받아야 함
    @State var selectedId: String = ""
    let callback: (String) -> ()
    
    var body: some View {
        HStack {
            ForEach(items) { item in
                SoundCard(id : item.name,
                               data: item,
                               callback: self.radioGroupCallback,
                               selectedID: self.selectedId)
            }
        }
    }
    
    func radioGroupCallback(id: String) {
        selectedId = id
        callback(id)
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
