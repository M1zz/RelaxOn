//
//  RelaxOnWidget.swift
//  RelaxOnWidget
//
//  Created by 이가은 on 2022/08/04.
//

import Intents
import WidgetKit
import SwiftUI

struct RelaxOnWidgetEntryView : View {
    //    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        if entry.isSample {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    Rectangle()
                        .scaledToFit()
                        .foregroundColor(Color.white.opacity(0.7))
                        .cornerRadius(4)
                    
                    Spacer()
                    Image("WidgetLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 17)
                }
                Text("Listen to Music and Relax ON")
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.systemGrey1)
                    .padding(.top, 14)
            }
            .padding(18)
            .background(
                Image("WidgetBackground")
                    .resizable()
                    .scaledToFit()
            )
            .widgetURL(entry.url)
        } else {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    ZStack{
                        Image(entry.baseImageName)
                            .resizable()
                            .scaledToFit()
                        Image(entry.melodyImageName)
                            .resizable()
                            .scaledToFit()
                        Image(entry.whiteNoiseImageName)
                            .resizable()
                            .scaledToFit()
                    }
                    .background(Color.white)
                    .cornerRadius(4)
                    
                    Spacer()
                    Image("WidgetLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 17)
                }
                Text(entry.isPlaying ? "NOW PLAYING" : "PAUSED")
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(Color.systemGrey1)
                    .padding(.top, 8)
                Text(entry.name)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.systemGrey1)
            }
            .padding(18)
            .background(
                ZStack{
                    Image(entry.baseImageName)
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 24)
                    Image(entry.melodyImageName)
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 24)
                    Image(entry.whiteNoiseImageName)
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 24)
                    Color.black.opacity(0.3)
                }
            )
            .widgetURL(entry.url)
        }
        
        // // TODO: 이후 큰 사이즈의 위젯이 추가되었을 때
        //        switch family {
        //            case .systemSmall:
        //                Text(entry.date, style: .time)
        //            case .systemMedium:
        //                Text("systemMedium")
        //            case .systemLarge:
        //                Text("systemLarge")
        //            case .systemExtraLarge:
        //                Text("systemExtraLarge")
        //            default:
        //                EmptyView()
        //        }
    }
}

@main
struct RelaxOnWidget: Widget {
    let kind: String = "RelaxOnWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: { entry in
            RelaxOnWidgetEntryView(entry: entry)
        })
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct RelaxOnWidget_Previews: PreviewProvider {
    static var previews: some View {
//        RelaxOnWidgetEntryView(entry: CDWidgetEntry.sample)
        RelaxOnWidgetEntryView(entry: CDWidgetEntry( baseImageName: BaseAudioName.oxygen.fileName, melodyImageName: MelodyAudioName.garden.fileName, whiteNoiseImageName: WhiteNoiseAudioName.umbrellaRain.fileName,id: 1, name: "Forest Relax", isPlaying: false))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
