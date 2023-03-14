//
//  SoundCardView.swift
//  RelaxOn
//
//  Created by hyunho lee on 5/24/22.
//

import SwiftUI
import AVFoundation


struct SoundCardView: View {
    // MARK: - State Properties
    @State var show = false
    
    // MARK: - General Properties
    let soundFileName: String
    let callback: ((String, OldSound)->())?
    let selectedID: String?
    var data: OldSound
    
    // MARK: - Life Cycles
    init(soundFileName: String,
         data: OldSound,
         callback: ((String, OldSound)->())? = nil,
         selectedID: String? = nil) {
        self.soundFileName = soundFileName
        self.data = data
        self.callback = callback
        self.selectedID = selectedID
    }

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 10) {
                if data.name == "Empty" {
                    ZStack {
                        Rectangle()
                            .frame(width: (deviceFrame.exceptPaddingWidth - 20 ) / 3 ,
                                   height: (deviceFrame.exceptPaddingWidth - 20 ) / 3,
                                   alignment: .center)
                            .border(selectedID == soundFileName ? .white : .clear, width: 2)
                            .cornerRadius(4)
                            .clipped()
                    }
                } else {
                    Image(data.fileName)
                        .resizable()
                        .frame(width: (deviceFrame.exceptPaddingWidth - 20 ) / 3,
                               height: (deviceFrame.exceptPaddingWidth - 20 ) / 3,
                               alignment: .center)
                        .border(selectedID == soundFileName ? .white : .clear, width: 2)
                        .cornerRadius(4)
                        .clipped()
                }

                HStack {
                    Text(LocalizedStringKey(data.name))
                        .fontWeight(.semibold)
                        .font(Font.system(size: 17))
                        .foregroundColor(Color.white)
                    Spacer()
                }
            }
            .onTapGesture {
                guard let callback = callback else {
                    return
                }
                callback(soundFileName, data)
            }
        }
    }
}

struct SoundCard_Previews: PreviewProvider {
    static var previews: some View {
        SoundCardView(soundFileName : "base_default",
                      data: SoundType.base.soundList.first ?? OldSound.empty(0, .base),
                  callback: {_,_  in },
                  selectedID: "")
        .background(Color.backgroundColor)
    }
}



