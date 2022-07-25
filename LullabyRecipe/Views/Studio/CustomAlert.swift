//
//  CustomAlert.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/26/22.
//

import SwiftUI

struct Background: View {
    var body: some View {
        Text("")
    }
}

struct CustomAlert: View {
    @Binding var textEntered: String
    @Binding var showingAlert: Bool
    @Binding var selected: SelectedType
    
    var body: some View {
        
        //            Color.clear
        //                .background(.ultraThinMaterial)
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(ColorPalette.tabBackground.color)
            
            VStack {
                HStack {
                    Spacer()
                    Button {
                        showingAlert.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(.white)
                    }
                }
                .padding()
                
                Text("Title for this recipe?")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                
                
                TextField("Enter title", text: $textEntered)
                    .padding(5)
                    .background(ColorPalette.tabBackground.color)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                Button {
                    // TODO: - id 문제 해결
                    let newSound = MixedSound(id: userRepositories.count,
                                              name: textEntered,
                                              baseSound: baseSound,
                                              melodySound: melodySound,
                                              naturalSound: naturalSound,
                                              imageName: recipeRandomName.randomElement()!)
                    userRepositories.append(newSound)
                    
                    let data = getEncodedData(data: userRepositories)
                    UserDefaultsManager.shared.standard.set(data, forKey: UserDefaultsManager.shared.recipes)
                    
                    showingAlert.toggle()
                    selected = .home
                } label: {
                    Text("Save")
                        .padding()
                        .frame(height: 35)
                        .background(ColorPalette.tabBackground.color)
                        .foregroundColor(ColorPalette.forground.color)
                }
            }
        }
        .frame(width: 300, height: 200)
//        .overlay(
//            RoundedRectangle(cornerRadius: 4)
//                .stroke(Color(UIColor.label), lineWidth: 2)
//        )
        
        
    }
    
    private func getEncodedData(data: [MixedSound]) -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            return encodedData
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        return nil
    }
}



struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(textEntered: .constant("text"),
                    showingAlert: .constant(true),
                    selected: .constant(.kitchen))
    }
}
