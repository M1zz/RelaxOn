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
    
    @State var txt = ""
    
    var body : some View {
        
        VStack(spacing: 15) {
            Profile()

            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    HomeBottomView()
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
    
    @ViewBuilder
    func SearchBar() -> some View {
        HStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.body)
                
                TextField("Search Groceries", text: $txt)
            }
            .padding(10)
            .background(Color("Color1"))
            .cornerRadius(20)
            
            Button(action: {
                
            }) {
                
                Image("mic").renderingMode(.original)
            }
        }
    }
    
    @ViewBuilder
    func MainBanner() -> some View {
        Image("top")
            .resizable()
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Text("New Sound Track")
                            .font(.title)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                }
                
            )
    }
    
    @ViewBuilder
    func CategorySectionTitle() -> some View {
        HStack {
            Text("Categories").font(.title)
            
            Spacer()
            
            Button(action: {
                
            }) {
                Text("More")
            }
            .foregroundColor(Color("Color"))
        }
        .padding(.vertical, 15)
    }
    
    @ViewBuilder
    func CategoryScroll() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack(spacing: 15){
                
                ForEach(categories,id: \.self){i in
                    
                    VStack{
                        Image(i)
                            .renderingMode(.original)
                        Text(i)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func HomeBottomView() -> some View {
        VStack(spacing: 15) {
            
            HStack {
                Text("Base Sound")
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
                    ForEach(freshitems){ item in
                        FreshCellView2(data: item)
                    }
                }
            }
            
            HStack{
                
                Text("Melody")
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("More")
                }.foregroundColor(Color("Color"))
                
            }
            .padding(.vertical, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 15){
                    ForEach(freshitems) { item in
                        FreshCellView2(data: item)
                    }
                }
            }
            
            HStack{
                
                Text("Natural Sound")
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("More")
                }.foregroundColor(Color("Color"))
                
            }
            .padding(.vertical, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 15){
                    ForEach(freshitems) { item in
                        FreshCellView2(data: item)
                    }
                }
            }
            
            
            
            
            
            Button {
                
            } label: {
                Text("Create")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(.green)
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
    
    var body : some View{
        
        ZStack {
            NavigationLink(destination: MusicView(data: data),
                           isActive: self.$show) {
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
                self.show.toggle()
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

struct FreshCellView2 : View {
    
    var data : fresh
    @State var show = false
    
    var body : some View {
        
        ZStack {
            
            
            VStack(spacing: 10) {
                Image(data.image)
                    .resizable()
                    .frame(width: 180,
                           height: 180,
                           alignment: .center)
                    .cornerRadius(10)
                    .border(!show ? .clear : .red, width: 3)
                    
                
//                    .frame(width: 200, height: 200, alignment: .center)
//                                .foregroundColor(.white)
//                                .background(Color.blue)
//                                .cornerRadius(16)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 16).stroke(Color.yellow, lineWidth: 8)
//                                )
                    
                Text(data.name)
                    .fontWeight(.semibold)
                Text(data.price)
                    .foregroundColor(.green)
                    .fontWeight(.semibold)
            }

            .onTapGesture {
                self.show.toggle()
            }
        }
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











//struct Detail : View {
//
//    @Binding var show : Bool
//    @State var top = UIApplication.shared.windows.last?.safeAreaInsets.top
//    @State var count = 0
//
//    var body : some View{
//
//        VStack(spacing: 0){
//
//            Image("header")
//                .resizable()
//                .frame(height: UIScreen.main.bounds.height / 2.5)
//                .edgesIgnoringSafeArea(.top)
//                .overlay(
//
//                    VStack{
//
//                        HStack(spacing: 12){
//
//                            Button(action: {
//
//                                self.show.toggle()
//
//                            }) {
//
//                                Image("back").renderingMode(.original)
//                            }
//
//                            Spacer()
//
//                            Button(action: {
//
//                            }) {
//
//                                Image("download").renderingMode(.original)
//                            }
//
//                            Button(action: {
//
//                            }) {
//
//                                Image("Wishlist").renderingMode(.original)
//                            }
//
//                        }.padding()
//
//                        Spacer()
//                    }
//
//                )
//
//            ScrollView(.vertical, showsIndicators: false) {
//
//                VStack(alignment: .leading,spacing: 15){
//
//                    Text("Seedless Lemon").font(.title)
//
//                    Text("30.00 / kg").foregroundColor(.green)
//
//                    Divider().padding(.vertical, 15)
//
//                    HStack{
//
//                        Image("rp1").renderingMode(.original)
//
//                        Text("Diana Organic Farm")
//
//                        Spacer()
//
//                        Button(action: {
//
//                        }) {
//
//                            Image("chat").renderingMode(.original)
//                        }
//                    }
//
//                    Text("Organic seedless lemon will enhance the flavor of all your favorite recipes, including chicken, fish, vegetables, and soups without the hassle of picking out the seeds. They are also fantastic in marinades, sauces, and fruit salads.").foregroundColor(.gray)
//
//                    HStack{
//
//                        Text("Reviews (48)")
//
//                        Spacer()
//
//                        Button(action: {
//
//                        }) {
//
//                            Text("More")
//
//                        }.foregroundColor(Color("Color"))
//
//                    }.padding(.vertical, 10)
//
//                    HStack{
//
//                        Image("rp2").renderingMode(.original)
//
//                        VStack(alignment: .leading, spacing: 6){
//
//                            HStack{
//
//                                Text("4")
//                                Image(systemName: "star.fill").foregroundColor(.yellow)
//
//                            }
//
//                            Text("Oh Yeon Seo")
//                            Text("The Lemon is So Fresh And Delivery is So Speed....")
//                        }
//
//                    }.padding()
//                        .background(Color("Color1"))
//                        .cornerRadius(12)
//
//                    HStack(spacing: 20){
//
//                        Spacer(minLength: 12)
//
//                        Button(action: {
//
//                            self.count += 1
//                        }) {
//
//                            Image(systemName: "plus.circle").font(.largeTitle)
//
//                        }.foregroundColor(.green)
//
//                        Text("\(self.count)")
//
//                        Button(action: {
//
//                            if self.count != 0{
//
//                                self.count -= 1
//                            }
//
//                        }) {
//
//                            Image(systemName: "minus.circle").font(.largeTitle)
//
//                        }.foregroundColor(.green)
//
//                        Button(action: {
//
//                        }) {
//
//                            Text("Add to Cart").padding()
//
//                        }.foregroundColor(.white)
//                            .background(Color("Color"))
//                            .cornerRadius(12)
//
//                        Spacer(minLength: 12)
//                    }
//                }
//
//            }.padding()
//                .overlay(
//
//
//                    VStack{
//
//                        HStack{
//
//                            Spacer()
//
//                            HStack{
//
//                                Text("4").foregroundColor(.white)
//                                Image(systemName: "star.fill").foregroundColor(.yellow)
//
//                            }.padding()
//                                .background(Color.green)
//                                .cornerRadius(12)
//                        }
//                        .padding(.top,-20)
//                        .padding(.trailing)
//
//
//                        Spacer()
//                    }
//
//                )
//                .background(RoundedCorner().fill(Color.white))
//                .padding(.top, -top! - 25)
//
//                .navigationBarTitle("")
//                .navigationBarHidden(true)
//                .navigationBarBackButtonHidden(true)
//        }
//    }
//}


//struct RoundedCorner : Shape {
//
//    func path(in rect: CGRect) -> Path {
//
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 35, height: 35))
//
//        return Path(path.cgPath)
//    }
//}
