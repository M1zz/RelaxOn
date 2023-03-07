//
//  MultiPreview.swift
//  RelaxOn
//
//  Created by hyo on 2022/08/16.
//

import SwiftUI

struct MultiPreview<V: View>: View {
    let content: () -> V
        
    var body: some View {
        content()
            .previewDevice("iPhone 13")
            .environment(\.locale, .init(identifier: "en"))
        content()
            .previewDevice("iPhone 13")
            .environment(\.locale, .init(identifier: "ko"))
        content()
            .previewDevice("iPhone SE (3rd generation)")
            .environment(\.locale, .init(identifier: "en"))
        content()
            .previewDevice("iPhone SE (3rd generation)")
            .environment(\.locale, .init(identifier: "ko"))
    }
}

struct Preview_Previews: PreviewProvider {
    static var previews: some View {
        MultiPreview {
            Text("베이스")
        }
    }
}
