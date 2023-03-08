//
//  SecondView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SecondView: View {
    var fileInfo: FileInfo
    
    var body: some View {
        Text("\(self.fileInfo.name)")
        NavigationLink("Selected Water Drop2", value: "10")
            .navigationDestination(for: String.self) { value in
                ThirdView()
            }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(fileInfo: FileInfo.init(name: "임시"))
    }
}
