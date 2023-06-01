//
//  ListenListCell.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/18.
//

import SwiftUI

/**
 커스텀 음원의 각 정보가 셀 안에 노출되는 View
 */
struct ListenListCell: View {
    
    var customSound: CustomSound
    
    var body: some View {
        VStack {
            HStack {
                Image(customSound.category.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .background(Color(hex: customSound.color))
                    .cornerRadius(8)
                
                Text(customSound.title)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.leading, 20)
                    .foregroundColor(Color(.Text))
                
                Spacer()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.ListenListCellUnderLine))
                .padding(.vertical, 2)
                .background(Color(.DefaultBackground))
        }
        .background(Color(.DefaultBackground))
    }
}

struct ListenListCell_Previews: PreviewProvider {
    static var previews: some View {
        ListenListCell(customSound: CustomSound(fileName: "임시 타이틀", category: .waterDrop, audioVariation: .init(), audioFilter: .WaterDrop, color:
                                                    ""))
    }
}
