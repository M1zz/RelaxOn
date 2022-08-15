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
        VStack {
            Image(entry.imageName)
                .resizable()
                .scaledToFit()
            Text(entry.name)
        }
        .padding(.vertical, 20)
        .widgetURL(entry.url)
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
        RelaxOnWidgetEntryView(entry: CDWidgetEntry(date: Date(), imageName: "Recipe5", id: 1, name: "temp"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
