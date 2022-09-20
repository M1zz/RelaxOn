//
//  Provider.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/05.
//

import WidgetKit

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> CDWidgetEntry {
        return CDWidgetEntry.sample
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CDWidgetEntry) -> Void) {
        completion(CDWidgetEntry.sample)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CDWidgetEntry>) -> Void) {
        completion(loadLatestMixedSoundData())
    }
    
    private func loadLatestMixedSoundData() -> Timeline<CDWidgetEntry> {
        
        let entry: CDWidgetEntry
        
        if let userDefault = UserDefaults(suiteName: WidgetManager.suiteName),
           let widgetData = userDefault.value(forKey: "smallWidgetData") as? Data,
           let data = try? JSONDecoder().decode(SmallWidgetData.self, from: widgetData) {
            entry = CDWidgetEntry(date: Date(), isSample: false, data: data)
        } else {
            entry = CDWidgetEntry.sample
        }
        
        return Timeline(entries: [entry], policy: .never)
    }
}
