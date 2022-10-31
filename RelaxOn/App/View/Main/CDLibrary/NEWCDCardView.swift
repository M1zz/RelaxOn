//
//  new_CDCardView.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/10/26.
//

import SwiftUI

struct NewCDCardView: View {
    @State var CD: CD
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.green)
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder()
            }
            .frame(width: UIScreen.main.bounds.width * 0.43, height: UIScreen.main.bounds.width * 0.43)
            .foregroundColor(.systemGrey3)
            Text(CD.name)
        }
    }
}

struct NewCDCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewCDCardView(CD: CD(name: "hi"))
    }
}
