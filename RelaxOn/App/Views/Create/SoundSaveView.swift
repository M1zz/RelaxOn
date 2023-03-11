//
//  SoundSaveView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundSaveView: View {
    var fileInfo: FileInfo
    var body: some View {
        Text("SoundSaveView \(fileInfo.name)")
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSaveView(fileInfo: FileInfo(name: "세번째"))
    }
}
