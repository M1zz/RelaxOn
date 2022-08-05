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

// Provider: 시간에 따른 위젯 업데이트 로직
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    // 위젯 갤러리에서 샘플로 보여질 부분
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    // 정의한 타임라인에 맞게 업데이트해서 보여질 내용
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .second, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        // policy: 이 타입이 위젯에 새로운 타임라인을 제공해주는 시기를 지정할 수 있도록 해줌
        //    .atEnd - 현재주어진 타임라인이 마지막일 때 새로 타임라인을 요청
        //    .after - 해당 date후에 새로운 타임라인 요청
        //    .never - 가능한 즉시 새로운 타임라인을 요청..?(A policy that specifies that the app prompts WidgetKit when a new timeline is available.)
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

// EntryView: 위젯을 표시하는 View
struct RelaxOnWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.date, style: .time)
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
    var body: some WidgetConfiguration {
        //    kind: 위젯의 identifier
        //    provider: 렌더링할 시기를 WidgetKit에 알려주는 타임라인을 생성함
        //    클로져: SwiftUI 뷰를 포함. WidgetKit는 이를 호출하여 내용을 렌더링하고 provider로부터 타임라인 entry 파라미터를 전달함
        //    intent: 사용자가 구성할 수 있는 속성을 정의
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            RelaxOnWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget") // 위젯 설명 타이틀
        .description("This is an example widget.") // 위젯 설명 부타이틀
        .supportedFamilies([.systemSmall]) // 위젯 크기 설정
    }
}

struct RelaxOnWidget_Previews: PreviewProvider {
    static var previews: some View {
        RelaxOnWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
