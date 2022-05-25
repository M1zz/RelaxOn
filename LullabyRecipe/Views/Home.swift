//
//  Home.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI

struct Home: View {
    
    @State var txt = ""
    @State var userName: String = ""
    @Binding var selected: SelectedType

    var body : some View {
        
        VStack(spacing: 15) {
            Profile()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    //SearchBar()
                    
                    MainBanner()
                    
                    //CategorySectionTitle()
                    
                    //CategoryScroll()

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
            
            Text("Hi, \(userName)")
                .font(.body)
            
            Spacer()
            
//            Button(action: {
//
//            }) {
//                Image("filter").renderingMode(.original)
//            }
        }
        .onAppear() {
            userName = UserDefaults.standard.string(forKey: "userName") ?? "Guest"
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
//            .background(Color("Beige"))
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
    
//    @ViewBuilder
//    func CategorySectionTitle() -> some View {
//        HStack {
//            Text("Theme").font(.title)
//
//            Spacer()
//
//            Button(action: {
//
//            }) {
//                Text("More")
//            }
//            .foregroundColor(Color("Pink"))
//        }
//        .padding(.vertical, 15)
//    }
    
//    @ViewBuilder
//    func CategoryScroll() -> some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//
//            HStack(spacing: 15){
//
//                ForEach(categories,id: \.self){i in
//
//                    VStack{
//                        Image(i)
//                            .renderingMode(.original)
//                        Text(i)
//                    }
//                }
//            }
//        }
//    }
    
    @ViewBuilder
    func HomeBottomView() -> some View {
        
        VStack(spacing: 15) {
            
            HStack {
                Text("My Recipe")
                    .font(.title)
                    .bold()
                
                Spacer()
                
//                Button(action: {
//
//                }) {
//                    Text("More")
//                }
//                .foregroundColor(Color("Pink"))
//
            }.padding(.vertical, 15)
            
            if userRepositories.isEmpty {
                VStack {
                    Text("Your first recipe has not been made yet.")
                    Button {
                        // TODO : Go to kitchen
                        selected = .kitchen
                    } label: {
                        Text("Go to create lullaby")
                    }

                }
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 15), count: 2),spacing: 20) {
                    ForEach(userRepositories){ item in
                        MixedSoundCard(data: item)
                    }
                    
                }
            }
            
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 15) {
//                    ForEach(userRepositories){ item in
//                        MixedSoundCard(data: item)
//                    }
//                }
//            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(selected: .constant(.home))
    }
}
