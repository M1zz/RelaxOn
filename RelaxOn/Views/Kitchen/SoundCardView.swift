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
    let callback: ((String, Sound)->())?
    let selectedID: String?
    var data: Sound
    
    // MARK: - Life Cycles
    init(soundFileName: String,
         data: Sound,
         callback: ((String, Sound)->())? = nil,
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
                            .background(.black)
                            .frame(width: (deviceFrame.exceptPaddingWidth - 20 ) / 3 ,
                                   height: (deviceFrame.exceptPaddingWidth - 20 ) / 3,
                                   alignment: .center)
                            .border(selectedID == soundFileName ? .white : .clear, width: 2)
                        Image(systemName: "moon.zzz.fill")
                            .resizable()
                            .frame(width: (deviceFrame.exceptPaddingWidth - 20 ) / 6,
                                   height: (deviceFrame.exceptPaddingWidth - 20 ) / 6)
                            .foregroundColor(.white)

                    }
                } else {
                    Image(data.fileName)
                        .resizable()
                        .frame(width: (deviceFrame.exceptPaddingWidth - 20 ) / 3,
                               height: (deviceFrame.exceptPaddingWidth - 20 ) / 3,
                               alignment: .center)
                        .border(selectedID == soundFileName ? .white : .clear, width: 2)
                }

                HStack {
                    let name = LocalizedStringKey(data.name)
                    Text(name)
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
                       data: baseSounds[0],
                  callback: {_,_  in },
                  selectedID: "")
        .background(ColorPalette.background.color)
    }
}



