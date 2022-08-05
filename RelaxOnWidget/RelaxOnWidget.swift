//
//  RelaxOnWidget.swift
//  RelaxOnWidget
//
//  Created by 이가은 on 2022/08/04.
//

import WidgetKit
import SwiftUI
import Intents
// [Swift] Realm 데이터 공유 (Widget과 Main앱 데이터 공유) https://nsios.tistory.com/175

// EntryView: 위젯을 표시하는 View
struct RelaxOnWidgetEntryView : View {
    //    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
                ZStack {
                    Image(entry.imageName)
//                    Image(entry.data.baseSound?.imageName ?? "")
//                            .resizable()
//                            .scaledToFit()
//                            .opacity(0.5)
//                    Image(entry.data.melodySound?.imageName ?? "")
//                            .resizable()
//                            .scaledToFit()
//                            .opacity(0.5)
//                    Image(entry.data.naturalSound?.imageName ?? "")
//                            .resizable()
//                            .scaledToFit()
//                            .opacity(0.5)
            }
            Text(entry.name)
            Image("\(entry.id)")
//            Text(entry.data.name)
        }
//        Text(entry.date, style: .time)
        .padding(.vertical, 20)
        .widgetURL(entry.url)
        #warning("widgetURL 추가")
        // 이후 추가 될 거임 ..!
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
    
    // WidgetConfiguration: 위젯 식별 및 위젯의 Content표시
    var body: some WidgetConfiguration { // WidgetConfiguration: Widget의 content를 나타내는 타입
        //    kind: 위젯의 identifier
        //    provider: 렌더링할 시기를 WidgetKit에 알려주는 타임라인을 생성함
        //    클로져: SwiftUI 뷰를 포함. WidgetKit는 이를 호출하여 내용을 렌더링하고 provider로부터 타임라인 entry 파라미터를 전달함
        StaticConfiguration(kind: kind, provider: Provider(), content: { entry in
            RelaxOnWidgetEntryView(entry: entry)
        })
        .configurationDisplayName("My Widget") // 위젯 설명 타이틀
        .description("This is an example widget.") // 위젯 설명 부타이틀
        .supportedFamilies([.systemSmall]) // 위젯 크기 설정
    }
}

struct RelaxOnWidget_Previews: PreviewProvider {
    static var previews: some View {
        RelaxOnWidgetEntryView(entry: CDWidgetEntry(date: Date(), imageName: "Recipe5", id: 1, name: "temp"))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
