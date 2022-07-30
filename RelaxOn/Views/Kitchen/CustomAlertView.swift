//
//  CustomAlertView.swift
//  LullabyRecipe
//
//  Created by hyunho lee on 5/26/22.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var textEntered: String
    @Binding var showingAlert: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray)
            VStack {
                Text("Title for this recipe?")
                    .font(.title3)
                    .foregroundColor(.black)
                TextField("Enter title", text: $textEntered)
                    .padding(5)
                    .background(.gray)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                Rectangle()
                    .frame(height: 0.7)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)

                HStack{
                    Button {
                        showingAlert.toggle()
                    } label: {
                        Text("Cancel")
                            .padding()
                            .frame(height: 35)
                            .background(.gray)
                            .foregroundColor(.black)
                    }.padding(.horizontal, 10)
                        .padding(.top, 15)

                    Spacer().frame(width: 50)

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
                    } label: {
                        Text("Save")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(height: 35)
                            .background(.gray)
                            .foregroundColor(.black)
                    }.padding(.horizontal,10)
                        .padding(.top, 15)
                }
            }.padding(.top, 40)
        }
        .frame(width: deviceFrame().screenWidth - 100 , height: deviceFrame().screenHeight - 620)
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



struct CustomAlertView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlertView(textEntered: .constant("text"),
                    showingAlert: .constant(true))
    }
}
