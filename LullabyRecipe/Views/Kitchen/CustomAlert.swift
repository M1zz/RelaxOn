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
        ZStack {
            Color.clear
                .background(.ultraThinMaterial)
            
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                VStack {
                    Text("What is your name of recipe?")
                        .font(.title3)
                        .foregroundColor(.black)
                    
                    
                    TextField("Enter text", text: $textEntered)
                        .padding(5)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            showingAlert.toggle()
                        } label: {
                            Text("Cancel")
                                .padding()
                                .frame(height: 35)
                                .background(Color(UIColor.label))
                                .foregroundColor(Color(UIColor.systemBackground))
                                .cornerRadius(4)
                            
                        }
                        
                        Button {
                            // Todo : 입력받은 이름 저장
                            let newSound = MixedSound(id: userRepositories.count,
                                                      name: textEntered,
                                                      sounds: mixedAudioSources,
                                                      imageName: recipeRandomName.randomElement()!)
                            userRepositories.append(newSound)
                            showingAlert.toggle()
                            selected = .home
                        } label: {
                            Text("Save")
                                .padding()
                                .frame(height: 35)
                                .background(Color(UIColor.systemBackground))
                                .foregroundColor(Color(UIColor.label))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color(UIColor.label), lineWidth: 2)
                                )
                                .cornerRadius(4)
                        }
                        
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(width: 300, height: 150)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(UIColor.label), lineWidth: 2)
            )
        }
    }
}



struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(textEntered: .constant("text"),
                    showingAlert: .constant(true),
                    selected: .constant(.kitchen))
    }
}
