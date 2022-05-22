//
//  Home.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI

struct Home: View {
    
    @State var txt = ""
    
    var body : some View {
        
        VStack(spacing: 15) {
            Profile()
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 15) {
                    //SearchBar()
                    
                    MainBanner()
                    
                    CategorySectionTitle()
                    
                    CategoryScroll()

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
            
            HStack{
                Text("Original Sound")
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    Text("More")
                }
                .foregroundColor(Color("Color"))
                
            }.padding(.vertical, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(freshitems){ item in
                        FreshCellView(data: item)
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
