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
            SampleWidget()
        } else {
            CurrentSoundWidget()
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

extension RelaxOnWidgetEntryView {
    @ViewBuilder
    func SampleWidget() -> some View {
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
    }
    @ViewBuilder
    func CurrentSoundWidget() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                ZStack {
                    Image(entry.data.baseImageName)
                        .resizable()
                        .scaledToFit()
                    Image(entry.data.melodyImageName)
                        .resizable()
                        .scaledToFit()
                    Image(entry.data.whiteNoiseImageName)
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
            Text(entry.data.isRecentPlay ? "RECENT PLAY" : (entry.data.isPlaying ? "NOW PLAYING" : "PAUSED"))
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundColor(Color.systemGrey1)
                .padding(.top, 8)
            Text(entry.data.name)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundColor(Color.systemGrey1)
        }
        .padding(18)
        .background(
            ZStack {
                if entry.data.isRecentPlay {
                    Image("WidgetBackground")
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(entry.data.baseImageName)
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 24)
                    Image(entry.data.melodyImageName)
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 24)
                    Image(entry.data.whiteNoiseImageName)
                        .resizable()
                        .scaledToFit()
                        .blur(radius: 24)
                    Color.black.opacity(0.3)
                }
            }
        )
        .widgetURL(entry.url)
    }
}

@main
struct RelaxOnWidget: Widget {
    let kind: String = WidgetManager.widgetName
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: { entry in
            RelaxOnWidgetEntryView(entry: entry)
        })
        .configurationDisplayName("Recently Played")
        .description("Quickly access recently played CDs.")
        .supportedFamilies([.systemSmall])
    }
}

struct RelaxOnWidget_Previews: PreviewProvider {
    static var previews: some View {
        RelaxOnWidgetEntryView(
            entry: CDWidgetEntry(
                date: Date(),
                isSample: false,
                data: SmallWidgetData(
                    baseImageName: BaseSound.oxygen.fileName,
                    melodyImageName: MelodySound.garden.fileName,
                    whiteNoiseImageName: WhiteNoiseSound.umbrellaRain.fileName,
                    name: "Forest Relax",
                    id: 1,
                    isPlaying: false,
                    isRecentPlay: false)
            )
        )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
