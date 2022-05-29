//
//  Home.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 2022/05/23.
//

import SwiftUI

struct Home: View {
    
    @State var txt = ""
    @Binding var userName: String?
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
        .onAppear {
            userName = UserDefaults.standard.string(forKey: "userName") ?? "Guest"
            
            if let data = UserDefaults.standard.data(forKey: "recipes") {
                do {
                    // Create JSON Decoder
                    let decoder = JSONDecoder()

                    // Decode Note
                    userRepositories = try decoder.decode([MixedSound].self, from: data)

                } catch {
                    print("Unable to Decode Note (\(error))")
                }
            }
        }
    }
    
    @ViewBuilder
    func Profile() -> some View {
        
        HStack(spacing: 12) {
            WhiteTitleText(title: "Hi, \(userName ?? "guest")")
            Spacer()
        }
        .padding(.vertical, 20)
    }
    
    @ViewBuilder
    func MainBanner() -> some View {
        Image("NewSoundtrack")
            .resizable()
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        WhiteTitleText(title: "New Soundtrack")
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
                emptySoundButton()
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
    
    @ViewBuilder
    func emptySoundButton() -> some View {
        Button {
            selected = .kitchen
        } label: {
            HStack {
                ZStack {
                    Rectangle()
                    // TODO: - 화면의 절반
                        .frame(width: 150,
                               height: 150)
                        .modifier(RoundedEdge(width: 1, color: ColorPalette.buttonBackground.color, cornerRadius: 20))
                        .foregroundColor(ColorPalette.background.color)
                    Image(systemName: "plus.circle.fill")
                        .frame(width: 30,
                               height: 30)
                        .foregroundColor(ColorPalette.buttonBackground.color)
                }
                Spacer()
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(userName: .constant("guest"), selected: .constant(.home))
    }
}
