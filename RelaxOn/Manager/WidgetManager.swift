//
//  WidgetManager.swift
//  RelaxOn
//
//  Created by 이가은 on 2022/08/06.
//

import WidgetKit

struct SmallWidgetData: Codable {
    let baseImageName: String
    let melodyImageName: String
    let whiteNoiseImageName: String
    let name: String
    let id: Int
    let isPlaying: Bool
    let isRecentPlay: Bool
}

final class WidgetManager {
    static let suiteName = "group.relaxOn.widget.appGroup"
    static let smallWidgetData = "smallWidgetData"
    static let widgetName = "RelaxOnWidget"
    static let lockScreenwidgetName = "RelaxOnLockScreenWidgetExtension"
    static let lockScreenWidgetData = "lockScreenWidgetData"

    static func addMainSoundToWidget(
        baseImageName: String,
        melodyImageName: String,
        whiteNoiseImageName: String,
        name: String,
        id: Int,
        isPlaying: Bool,
        isRecentPlay: Bool) {
        let data = SmallWidgetData(
            baseImageName: baseImageName,
            melodyImageName: melodyImageName,
            whiteNoiseImageName: whiteNoiseImageName,
            name: name,
            id: id,
            isPlaying: isPlaying,
            isRecentPlay: isRecentPlay)
        if let encodedData = try? JSONEncoder().encode(data),
           let UserDefaultsAppGroup = UserDefaults(suiteName: suiteName) {
            UserDefaultsAppGroup.set(encodedData, forKey: smallWidgetData)
        }
        WidgetCenter.shared.reloadTimelines(ofKind: widgetName)
    }
    
    static func closeApp() {
        if let UserDefaultsAppGroup = UserDefaults(suiteName: suiteName),
           let savedData = UserDefaultsAppGroup.object(forKey: smallWidgetData) as? Data,
           let loadedData = try? JSONDecoder().decode(SmallWidgetData.self, from: savedData) {
            let savedSmallWidgetData = loadedData
            let data = SmallWidgetData(
                baseImageName: savedSmallWidgetData.baseImageName,
                melodyImageName: savedSmallWidgetData.melodyImageName,
                whiteNoiseImageName: savedSmallWidgetData.whiteNoiseImageName,
                name: savedSmallWidgetData.name,
                id: savedSmallWidgetData.id,
                isPlaying: savedSmallWidgetData.isPlaying,
                isRecentPlay: true)
            if let encodedData = try? JSONEncoder().encode(data),
               let UserDefaultsAppGroup = UserDefaults(suiteName: suiteName) {
                UserDefaultsAppGroup.set(encodedData, forKey: smallWidgetData)
            }
            WidgetCenter.shared.reloadTimelines(ofKind: widgetName)
        }
    }
    
    static func setupTimerToLockScreendWidget(settedSeconds: Double) {
         if let UserDefaultsAppGroup = UserDefaults(suiteName: suiteName) {
             UserDefaultsAppGroup.set(settedSeconds, forKey: lockScreenWidgetData)
             WidgetCenter.shared.reloadTimelines(ofKind: lockScreenwidgetName)
         }
     }
    
    static func getURL(id: Int) -> URL? {
        if let url = URL(string: "RelaxOn:///MixedSound\(id)") {
            return url
        } else {
            return nil
        }
    }
}
