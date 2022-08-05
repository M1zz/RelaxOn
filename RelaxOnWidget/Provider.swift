//
//  Provider.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/05.
//

import Foundation
import WidgetKit

// Provider: 시간에 따른 위젯 업데이트 로직
struct Provider: TimelineProvider {
    // StaticConfiguration
    
    func placeholder(in context: Context) -> CDWidgetEntry {
        return CDWidgetEntry.sample
    }
    
    // 위젯 갤러리에서 샘플로 보여질 부분
    func getSnapshot(in context: Context, completion: @escaping (CDWidgetEntry) -> Void) {
        completion(CDWidgetEntry.sample)
    }
    // 정의한 타임라인에 맞게 업데이트해서 보여질 내용
    func getTimeline(in context: Context, completion: @escaping (Timeline<CDWidgetEntry>) -> Void) {
        // timeline: Widget을 언제 업데이트 할지, 즉 Date를 담은 배열(entries)이 필요함
        completion(loadLatestMixedSoundData())
    }
    
    private func loadLatestMixedSoundData() -> Timeline<CDWidgetEntry> {
        //  policy: 이 타입이 위젯에 새로운 타임라인을 제공해주는 시기를 지정할 수 있도록 해줌
        //  .atEnd - 현재주어진 타임라인이 마지막일 때 새로 타임라인을 요청
        //  .after - 해당 date후에 새로운 타임라인 요청
        //  .never - 필요할 때에 새로운 타임라인을 요청
        
        let entry: CDWidgetEntry
        
        #warning("return 값 고치기")
        guard let id: Int = UserDefaults(suiteName: "group.widget.relaxOn")!.value(forKey: "id") as? Int else {
            entry = CDWidgetEntry(date: Date(), imageName: "Recipe5", id: 0, name: "error22")
            return Timeline(entries: [entry], policy: .never)
        }
        guard let title: String = UserDefaults(suiteName: "group.widget.relaxOn")!.value(forKey: "name") as? String else {
            entry = CDWidgetEntry(date: Date(), imageName: "Recipe5", id: 1, name: "error2")
            return Timeline(entries: [entry], policy: .never)
        }
        
        entry = CDWidgetEntry(date: Date(), imageName: "Recipe5", id: id, name: title)
        
        
        return Timeline(entries: [entry], policy: .never)
//
//        if let data = UserDefaults(suiteName: "group.widget.relaxOn")!.value(forKey: "recipe") as? Data {
//            do {
//                let decoder = JSONDecoder()
//                mixedSounds = try decoder.decode([MixedSound].self, from: data)
//                if let data: MixedSound = mixedSounds.first {
//                    entry = CDWidgetEntry(date: Date())
//                } else {
//                    entry = CDWidgetEntry.sample
//                }
//                return Timeline(entries: [entry], policy: .never)
//            } catch {
//                entry = CDWidgetEntry.sample
//                return Timeline(entries: [entry], policy: .never)
//            }
//        } else {
//            entry = CDWidgetEntry.sample
//            return Timeline(entries: [entry], policy: .never)
//        }
    }
}
