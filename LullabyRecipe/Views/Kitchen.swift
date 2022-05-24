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
 
    var body : some View {
        
        VStack(spacing: 15) {
            Profile()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    HomeBottomView(sectionTitle: "Base Sound")
                    
                    //HomeBottomView(sectionTitle: "Melody")
                    
                    //HomeBottomView(sectionTitle: "Natural Sound")
                    
                    Button {
                        
                    } label: {
                        Text("Create")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(.green)
                    }
                }
            }
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

    @ViewBuilder
    func HomeBottomView(sectionTitle: String) -> some View {
        VStack(spacing: 15) {
            
            HStack {
                Text(sectionTitle)
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("More")
                }
                .foregroundColor(Color("Color"))
                
            }.padding(.vertical, 15)
            
            ScrollView(.horizontal,
                       showsIndicators: false) {
                HStack(spacing: 15) {
                    //                    ForEach(freshitems){ item in
                    //                        FreshCellView2(data: item)
                    //                    }
                    
                    RadioButtonGroup(items: baseSounds,
                                     selectedId: "Base") { baseSelected in
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

struct RoundedEdge: ViewModifier {
    let width: CGFloat
    let color: Color
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content.cornerRadius(cornerRadius - width)
            .padding(width)
            .background(color)
            .cornerRadius(cornerRadius)
    }
}



struct RecipeCellView : View {
    
    var data : recipe
    
    var body : some View {
        
        VStack(spacing: 10) {
            Image(data.image)
            
            HStack(spacing: 10) {
                Image(data.authorpic)
                
                VStack(alignment: .leading, spacing: 6){
                    Text(data.name)
                        .fontWeight(.semibold)
                    Text(data.author)
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}


//enum SoundType {
//    case base
//    case melody
//    case natural
//}
