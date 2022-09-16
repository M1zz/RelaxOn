//
//  LockScreenWidgetExtension.swift
//  LockScreenWidgetExtension
//
//  Created by Minkyeong Ko on 2022/09/15.
//

import Intents
import WidgetKit
import SwiftUI

@available(iOS 16, *)
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CDLockScreenWidgetEntry {
        CDLockScreenWidgetEntry()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CDLockScreenWidgetEntry) -> Void) {
        let entry = CDLockScreenWidgetEntry()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CDLockScreenWidgetEntry>) -> Void)  {
        var entries: [CDLockScreenWidgetEntry] = []
        let currentDate = Date()
        
        if var timerData = UserDefaults(suiteName: WidgetManager.suiteName)!.value(forKey: WidgetManager.lockScreenWidgetData) as? Double {
            let endDate = Calendar.current.date(byAdding: .second, value: Int(timerData), to: currentDate)
            var addedSeconds: Double = 0
            print("됐음둥1", timerData)
            while timerData >= 0 {
                let entry = CDLockScreenWidgetEntry(date: currentDate + addedSeconds, startDate: currentDate, endDate: endDate ?? Date(), settedSeconds: timerData)
                entries.append(entry)
                timerData -= 60
                addedSeconds += 60
                entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
            //MARK: - 주석 나중에 Dake가 삭제하겠습니다.
            //            if currentDate >= endDate {
            //                let entry = CDLockScreenWidgetEntry(date: nowDate, endDate: endDate, settedSeconds: 0)
            //                let timeline = Timeline(entries: [entry], policy: .never)
            //                completion(timeline)
            //            }
            UserDefaults(suiteName: WidgetManager.suiteName)?.removeObject(forKey: WidgetManager.lockScreenWidgetData)
        } else {
            let entry = CDLockScreenWidgetEntry()
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
            print("안됐음둥")
        }
    }
}

@available(iOS 16, *)
struct CDLockScreenWidgetEntry: TimelineEntry {
    let date: Date
    let startDate: Date
    let endDate: Date
    let timerUrl: URL?
    let settedSeconds: Double
    
    init(date: Date = Date(), startDate: Date = Date(), endDate: Date = Date() + 0.1, settedSeconds: Double = 0.0) {
        self.date = date
        self.startDate = startDate
        self.endDate = endDate
        self.timerUrl = URL(string: "RelaxOn:///TimerSettingView")
        self.settedSeconds = settedSeconds
    }
}

@available(iOS 16, *)
struct RelaxOnLockScreenWidgetExtensionEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryRectangular:
            ProgressView(timerInterval: entry.startDate...entry.endDate) {
                HStack {
                    //TODO: river가 올려주신 R아이콘으로 바꿔야함
                    Image("WidgetLogo")
                    Spacer()
                    Text("\(Int(entry.settedSeconds / 60)) min")
                }
            } currentValueLabel: {
                //MARK: - default로 주는 타이머가 멈춰있어서 비워놓음
            }
            .progressViewStyle(.linear)
            .widgetURL(entry.timerUrl)
        default:
            EmptyView()
        }
    }
}

@main
struct RelaxOnLockScreenWidgetExtension: Widget {
    let kind: String = "RelaxOnLockScreenWidgetExtension"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RelaxOnLockScreenWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
#if os(watchOS)
        .supportedFamilies([.accessoryRectangular])
#else
        .supportedFamilies([.accessoryRectangular])
#endif
    }
}

@available(iOS 16, *)
struct RelaxOnLockScreenWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        RelaxOnLockScreenWidgetExtensionEntryView(entry: CDLockScreenWidgetEntry(date: Date(), endDate: Date().addingTimeInterval(10)))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
            .previewDisplayName("Circular")
    }
}
