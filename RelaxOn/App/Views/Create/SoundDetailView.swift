//
//  SoundDetailView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundDetailView: View { // SoundDetail
    var fileName: String?

    var body: some View {
        VStack {
            Text("\(self.fileName ?? "")")
            NavigationLink(destination: SoundSaveView(fileInfo: FileInfo(name: fileName ?? ""))) {
                Text("SoundSaveView")
            }
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDetailView(fileName: "")
    }
}
