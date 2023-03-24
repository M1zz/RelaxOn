//
//  SoundSaveView.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/03/07.
//

import SwiftUI

struct SoundSaveView: View {

    @Binding var volume: Float
    
    var body: some View {
        Text("\(volume)")
    }
}

struct SoundSaveView_Previews: PreviewProvider {
    static var previews: some View {
        SoundSaveView(volume: .constant(Float()))
    }
}
