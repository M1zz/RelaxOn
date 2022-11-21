//
//  VolumeSliderView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/10/31.
//

import SwiftUI

struct VolumeSliderView: View {
    @Binding var material: Material
    
    var body: some View {
        Text("sklms")
        Slider(value: $material.audioVolume, in: 0...1)
            .background(.black)
            .cornerRadius(4)
            .accentColor(.white)
            .padding(.horizontal, 20)
            .onChange(of: material.audioVolume) { newValue in
                material.audioVolume = newValue
            }
        Text(String(Int(material.audioVolume * 100)))
            .foregroundColor(.systemGrey1)
            .onAppear {
                print("volume", material.audioVolume)
            }
    }
}
