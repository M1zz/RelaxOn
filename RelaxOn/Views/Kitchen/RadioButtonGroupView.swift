//
//  RadioButtonGroupView.swift
//  RelaxOn
//
//  Created by Moon Jongseek on 2022/08/25.
//

import SwiftUI

struct RadioButtonGroupView: View {
    @State var selectedId = ""
    let items : [Sound] // sound 를 받아야 함
    let callback: (Sound) -> ()
    let columns = [
        GridItem(.adaptive(minimum: (deviceFrame.exceptPaddingWidth - 20 ) / 3))
    ]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(items) { item in
                SoundCardView(soundFileName : item.name,
                          data: item,
                          callback: radioGroupCallback,
                          selectedID: selectedId)
            }
        }
    }

    func radioGroupCallback(id: String, audio: Sound) {
        selectedId = id
        callback(audio)
    }
}

struct RadioButtonGroupView_Previews: PreviewProvider {
    static var previews: some View {
        RadioButtonGroupView(items: [], callback: { _ = $0 })
    }
}
