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
        ZStack {
            ColorPalette.background.color.ignoresSafeArea()
            
            VStack(spacing: 15) {
                Profile()
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 15) {
                        MainBanner()
                        
                        HomeBottomView()
                    }
                }
            }
            .padding(.horizontal)
                
        }
    }
    
    @ViewBuilder
    func Profile() -> some View {
        
        HStack(spacing: 12) {
            WhiteTitleText(title: "Hi, \(userName)")
            Spacer()
        }
        .padding(.vertical, 20)
        .onAppear() {
            userName = UserDefaults.standard.string(forKey: "userName") ?? "Guest"
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
                        WhiteTitleText(title: "New Sound Track")
                        Spacer()
                    }
                    .padding()
                }
                
            )
    }
    
    @ViewBuilder
    func HomeBottomView() -> some View {
        
        VStack(spacing: 15) {
            
            HStack {
                WhiteTitleText(title: "My Recipe")
                
                Spacer()
            }.padding(.vertical, 15)
            
            if userRepositories.isEmpty {
                VStack {
                    WhiteTitleText(title: "Your first recipe has not been made yet.")
                    Button {
                        selected = .kitchen
                    } label: {
                        Text("Go to create lullaby")
                    }
                }
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 15), count: 2),
                          spacing: 20) {
                    ForEach(userRepositories){ item in
                        MixedSoundCard(data: item)
                    }
                    
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(selected: .constant(.home))
    }
}
